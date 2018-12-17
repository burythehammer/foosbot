module "foosbot-ecs" {
  source = "../foosbot-ecs"
  foosball_channel = "${var.foosball_channel}"
  slack_token = "${var.slack_token}"
  bot_user = "${var.bot_user}"
  admin_user = "${var.admin_user}"
  results_bucket = "${module.foosbot-results.result_bucket_name}"
}

module "foosbot-results" {
  source = "../foosbot-results"
  env = "${var.env}"
}

