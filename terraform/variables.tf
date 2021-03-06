variable "aws_region" {
  description = "The AWS region to create things in."
  default = "us-east-1"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default = "377469707739.dkr.ecr.us-east-1.amazonaws.com/foosbot:latest"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default = 1
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default = "512"
}

variable "az_count" {
  default = 1
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default = 3000
}