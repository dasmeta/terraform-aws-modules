# Create sns topic for sms notifications
resource "aws_sns_topic" "k8s-alerts-notify-sms" {
  count = length(var.sns_subscription_phone_number_list) > 0 ? 1 : 0

  name              = "${replace(var.alarm_name, ".", "-")}-sms"
  kms_master_key_id = var.kms_master_key_id
  delivery_policy   = <<EOF
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

# Subscribe sns to sms
resource "aws_sns_topic_subscription" "sms" {
  count = length(var.sns_subscription_phone_number_list)

  topic_arn = aws_sns_topic.k8s-alerts-notify-sms[0].arn
  protocol  = "sms"
  endpoint  = element(var.sns_subscription_phone_number_list, count.index)
}
