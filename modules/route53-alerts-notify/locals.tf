locals {
  notify_slack    = var.slack_hook_url == null ? false : true
  notify_opsgenie = length(var.opsgenie_endpoint) > 0 ? true : false
  notify_sms      = length(var.sns_subscription_phone_number_list) > 0 ? true : false
  notify_email    = length(var.sns_subscription_email_address_list) > 0 ? true : false

  # multiple topics are optional. We filter the ones not used.
  alarm_actions = [
    for topic in [
      local.notify_email ? aws_sns_topic.this-email[0].arn : null,                            // email
      local.notify_sms ? aws_sns_topic.this-sms[0].arn : null,                                // sms
      local.notify_opsgenie ? aws_sns_topic.this-opsgenie[0].arn : null,                      // Opsgenie
      local.notify_slack ? data.aws_sns_topic.aws_sns_topic_slack_health_check[0].arn : null, // slack
      var.sns_topic_arn                                                                       // custom topic
    ] :
    topic if topic != null
  ]
}
