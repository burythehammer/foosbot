# Specify the provider and access details

provider "aws" {
  region = "${var.aws_region}"
}

### ECS

resource "aws_ecs_cluster" "foosbot-cluster" {
  name = "foosbot-cluster"
}

resource "aws_ecs_task_definition" "foosbot-task" {
  family = "foosbot-task-family"

  requires_compatibilities = [
    "FARGATE"]

  task_role_arn = "arn:aws:iam::377469707739:role/ecsTaskExecutionRole"
  execution_role_arn = "arn:aws:iam::377469707739:role/ecsTaskExecutionRole"

  network_mode = "awsvpc"

  memory = "${var.fargate_memory}"
  cpu = "${var.fargate_cpu}"

  container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.fargate_cpu},
    "image": "${aws_ecr_repository.foosbot-repo.repository_url}:latest",
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
      "name": "BOT_USER",
      "value": "${var.botuser}"
    },
 {
      "name": "ADMIN_USER",
      "value": "${var.adminuser}"
    },
 {
      "name": "FOOSBALL_CHANNEL",
      "value": "${var.foosball_channel}"
    },
   {
      "name": "SLACK_TOKEN",
      "value": "${var.slacktoken}"
    }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "foosbot-ecs-service" {
  name = "foosbot-ecs-service"
  cluster = "${aws_ecs_cluster.foosbot-cluster.id}"
  task_definition = "${aws_ecs_task_definition.foosbot-task.arn}"
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
    security_groups = [
      "${aws_security_group.foosball-security-group.id}"]
    subnets = [
      "${aws_subnet.public.*.id}"]
    assign_public_ip = true
  }
}

### ECR

resource "aws_ecr_repository"  "foosbot-repo" {
  name = "foosbot-ecr-repository"

  provisioner "local-exec" {
    command = "cd .. && docker build -t ${aws_ecr_repository.foosbot-repo.name} . && docker tag ${aws_ecr_repository.foosbot-repo.name}:latest ${aws_ecr_repository.foosbot-repo.repository_url}:latest && docker push ${aws_ecr_repository.foosbot-repo.repository_url}:latest"
  }
}