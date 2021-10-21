provider "aws" {
  region = "eu-central-1"
}
# resource "aws_kms_key" "this" {
#   description = "KMS key for notify-slack test"
# }
# # Encrypt the URL, storing encryption here will show it in logs and in tfstate
# # https://www.terraform.io/docs/state/sensitive-data.html
# resource "aws_kms_ciphertext" "slack_url" {
#   plaintext = "https://hooks.slack.com/services/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"
#   key_id    = aws_kms_key.this.arn
# }
module "notify_slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "4.18.0"
  # insert the 11 required variables here

  sns_topic_name = var.instance-id

  lambda_function_name = var.instance-id

  slack_webhook_url = "https://hooks.slack.com/services/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"
  slack_channel     = "aws-notification"
  slack_username    = "reporter"

  # kms_key_arn = aws_kms_key.this.arn

  lambda_description = "Lambda function which sends notifications to Slack"
  log_events         = true

  # VPC
  #  lambda_function_vpc_subnet_ids = module.vpc.intra_subnets
  #  lambda_function_vpc_security_group_ids = [module.vpc.default_security_group_id]

  tags = {
    Name = "cloudwatch-alerts-to-slack"
  }
}
    
resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name          = ":x: ${var.instance-id} - Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "0.80"
  alarm_description   = "${var.instance-id} CPU over load"

  alarm_actions = [module.notify_slack.this_slack_topic_arn]

  dimensions = var.dimensions
}
resource "aws_cloudwatch_metric_alarm" "ok" {
  alarm_name          = ":white_check_mark: ${var.instance-id} - Ok"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "0.80"
  alarm_description   = "${var.instance-id} CPU it's ok"

  ok_actions = [module.notify_slack.this_slack_topic_arn]

  dimensions = var.dimensions
}
######
# VPC
######
# resource "random_pet" "this" {
#   length = 2
# }

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = random_pet.this.id
#   cidr = "10.10.0.0/16"

#   azs           = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
#   intra_subnets = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
# }
