terraform {
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.5.0"
        }
    }
}

provider "aws" {
  region = "us-east-1"
}

#SNS TOPIC creates SNS Topic resources on AWS
resource "aws_sns_topic" "default" {
  count = var.enabled && var.enable_topic ? 1 : 0

  name                                     = "katrin-test"// module.labels.id
  display_name                             = var.display_name
  policy                                   = var.policy
}

#SNS TOPIC SUBSCRIPTION creates SNS Topic Subscription resources on AWS
resource "aws_sns_topic_subscription" "this" {
  for_each                        = var.subscribers
  topic_arn                       = join("", aws_sns_topic.default.*.arn)
  protocol                        = var.subscribers[each.key].protocol
  endpoint                        = var.subscribers[each.key].endpoint
  endpoint_auto_confirms          = var.subscribers[each.key].endpoint_auto_confirms
}

resource "aws_cloudwatch_event_rule" "check-scheduler-event" {
    name = "check-scheduler-event"
    description = "check-scheduler-event"
    schedule_expression = "${lookup(var.AutoStopSchedule, var.schedule_expression)}"
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.check-scheduler-event.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.default[0].arn
}

