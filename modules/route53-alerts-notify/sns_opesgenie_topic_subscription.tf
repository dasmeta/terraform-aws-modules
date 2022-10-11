# Create sns topic for opsgenie notifications
resource "aws_sns_topic" "this-opsgenie" {
  count = local.notify_opsgenie ? 1 : 0
  name  = "${replace("${var.domain_name}${var.resource_path}", "/[./]+/", "-")}-opsgenie"

  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

# Subscribe sns to opsgenie
resource "aws_sns_topic_subscription" "opsgenie" {
  count     = length(var.opsgenie_endpoint)
  topic_arn = aws_sns_topic.this-opsgenie[0].arn
  protocol  = "https"
  endpoint  = element(var.opsgenie_endpoint, count.index)
}
