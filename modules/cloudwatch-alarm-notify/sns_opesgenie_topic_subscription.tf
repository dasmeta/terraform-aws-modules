# Create sns topic for opsgenie notifications
resource "aws_sns_topic" "k8s-alerts-notify-opsgenie" {
  name = "${replace(var.alarm_name, ".", "-")}-opsgenie"

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
  topic_arn = aws_sns_topic.k8s-alerts-notify-opsgenie.arn
  protocol  = "https"
  endpoint  = var.opsgenie_endpoint
}
