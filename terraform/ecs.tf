# Specify the provider and access details

provider "aws" {
  region = "${var.aws_region}"
}

### ECS

resource "aws_ecs_cluster" "main" {
  name = "foosbot-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family = "app"
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
    "image": "${var.app_image}",
    "memory": ${var.fargate_memory},
    "name": "app",
    "networkMode": "awsvpc",
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

resource "aws_ecs_service" "main" {
  name = "tf-ecs-service"
  cluster = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count = "${var.app_count}"
  launch_type = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = ["${aws_subnet.private.*.id}"]
    assign_public_ip = true
  }
}