resource "aws_sns_topic" "default" {
  name                                     = var.name
  display_name                             = "${var.name} cronjob"
}

# resource "aws_sns_topic_subscription" "this" {
#   for_each                        = var.subscribers
#   topic_arn                       = join("", aws_sns_topic.default.*.arn)
#   protocol                        = var.protocol
#   endpoint                        = var.endpoint
#   endpoint_auto_confirms          = var.endpoint_auto_confirms
# }

resource "aws_cloudwatch_event_rule" "check-scheduler-event" {
    name ="${var.name}-cronjob-check-scheduler-event"
    description = "${var.name} cronjob schedule"
    schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.check-scheduler-event.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.default.arn
}