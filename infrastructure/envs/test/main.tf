module "foosbot" {
  source = "../../modules/foosbot"
  foosball_channel = "${var.foosball_channel}"
  admin_user = "${var.admin_user}"
  bot_user = "${var.bot_user}"
  slack_token = "${var.slack_token}"
  env = "${var.env}"
}