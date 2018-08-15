variable "aws_region" {
  description = "The AWS region to create things in."
  default = "eu-west-1"
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

variable "foosbot_log_level" {
  default = "WARNING"
}

variable "slacktoken" {
}

variable "botuser" {
}

variable "adminuser" {
}

variable "foosball_channel" {
}