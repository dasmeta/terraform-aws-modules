# Create sns topic for email notifications (should share same region with provider)
resource "aws_sns_topic" "route53-healthcheck_email" {
  provider                  = aws.virginia

  name = "${replace(var.domen_name, ".", "-")}-email"

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

resource "null_resource" "email-list_health-check" {
  triggers = {
    email_list = join(" ", var.sns_subscription_email_address_list)
  }

  # Create subscriptions to existing sns topic on alarm creation
  provisioner "local-exec" {
    command = "sh ${path.module}/sns_subscription.sh"
    environment = {
      sns_arn = aws_sns_topic.route53-healthcheck_email.arn
      sns_emails = join(" ", var.sns_subscription_email_address_list)
    }
  }
}
