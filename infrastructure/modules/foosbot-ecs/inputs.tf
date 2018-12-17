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
  description = "Log level that foosbot will output at"
  default = "WARNING"
}

variable "slack_token" {
  description = "Token used to authenticate with slack. Keep secret."
}

variable "bot_user" {
  description = "Slack user that bot will assume in channel"
}

variable "admin_user" {
  description = "User that bot will message / contact if things go wrong"
}

variable "foosball_channel" {
  description = "Channel that users will log their scores and communicate with foosbot with"
}

variable "results_bucket" {}