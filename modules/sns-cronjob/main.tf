resource "aws_sns_topic" "this" {
  name                              = var.name
  display_name                      = "${var.name} cronjob"
  http_success_feedback_role_arn    = aws_iam_role.success_logger.arn
  http_failure_feedback_role_arn    = aws_iam_role.failure_logger.arn
  http_success_feedback_sample_rate = var.success_sample_percentage
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "https"
  endpoint  = var.endpoint
  # endpoint_auto_confirms = var.endpoint_auto_confirms
}

resource "aws_cloudwatch_event_rule" "event_scheduler" {
  name                = "${var.name}-event-scheduler"
  description         = "${var.name} scheduler"
  schedule_expression = var.schedule
}

resource "aws_cloudwatch_event_target" "event_target" {
  rule      = aws_cloudwatch_event_rule.event_scheduler.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.this.arn
  input     = var.input
}
