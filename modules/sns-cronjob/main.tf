resource "aws_sns_topic" "this" {
  name                              = var.name
  display_name                      = "${var.name} cronjob"
  http_success_feedback_role_arn    = aws_iam_role.logger.arn
  http_failure_feedback_role_arn    = aws_iam_role.logger.arn
  http_success_feedback_sample_rate = var.success_sample_percentage
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "https"
  endpoint  = var.endpoint
}

resource "aws_cloudwatch_event_rule" "this" {
  name                = "${var.name}-cron-scheduler"
  description         = "${var.name} scheduler"
  schedule_expression = var.schedule
  is_enabled          = var.is_enabled
}

resource "aws_cloudwatch_event_target" "this" {
  rule  = aws_cloudwatch_event_rule.this.name
  arn   = aws_sns_topic.this.arn
  input = var.input

  dead_letter_config {
    arn = aws_sqs_queue.dead_letter_queue.arn
  }
}

resource "aws_sqs_queue" "dead_letter_queue" {
  name                      = "${var.name}-cron-dlq"
  message_retention_seconds = 1209600 # 14 days
}
