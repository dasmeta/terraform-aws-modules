resource "aws_sns_topic" "default" {
  count = var.enabled ? 1 : 0
  name                                     = var.id
}

resource "aws_cloudwatch_event_rule" "check-scheduler-event" {
    name = "check-scheduler-event"
    description = var.description
    schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.check-scheduler-event.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.default[0].arn
}