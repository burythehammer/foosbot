# Specify the provider and access details

provider "aws" {
  region = "${var.aws_region}"
}

### ECS

resource "aws_ecs_cluster" "main" {
  name = "foosbot-cluster"
}

resource "aws_ecs_task_definition" "foosbot-task" {
  family = "foosbot"
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"]
  cpu = "${var.fargate_cpu}"
  memory = "${var.fargate_memory}"

  execution_role_arn = "${data.aws_iam_role.ecs_task_execution_role.arn}"
  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.fargate_cpu},
    "image": "${aws_ecr_repository.foosbot-repo.repository_url}:1",
    "memory": ${var.fargate_memory},
    "name": "foosbot",
    "networkMode": "awsvpc",

    "environment": [

    {
      "name": "LOG_LEVEL",
      "value": "${var.foosbot_log_level}"
    },

   {
      "name": "AWS_ACCESS_KEY",
      "value": "${aws_iam_access_key.foosbot-user-key.id}"
    },

   {
      "name": "AWS_SECRET_KEY",
      "value": "${aws_iam_access_key.foosbot-user-key.secret}"
    },

   {
      "name": "S3_BUCKET",
      "value": "${aws_s3_bucket.result-bucket.bucket}"
    },
   {
      "name": "SLACK_TOKEN",
      "value": "${var.slacktoken}"
    }
    ],

    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "foosbot-ecs-service" {
  name = "foosbot-ecs-service"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.foosbot-task.arn}"
  desired_count = "${var.app_count}"
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [
      "${aws_security_group.ecs_tasks.id}"]
    subnets = [
      "${aws_subnet.private.*.id}"]
    assign_public_ip = true
  }
}

### ECR

resource "aws_ecr_repository" "foosbot-repo" {
  name = "foosbot-ecr-repository"

  provisioner "local-exec" {
    command = "cd .. && docker build -t ${aws_ecr_repository.foosbot-repo.repository_url} . && docker push ${aws_ecr_repository.foosbot-repo.repository_url}"
  }
}