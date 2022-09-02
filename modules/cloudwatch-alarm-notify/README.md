Module use examples.

# Example 1

In this case, you can create alarm default parameters using only alert type.

```
module "cloudwatchalarm" {
    source           = "dasmeta/modules/aws//modules/cloudwatch-alarm-notify"
    alarm_name       = "alarmname"
    # Type  k8s_alerts, alb_alerts
    alert_type_name  = "k8s_alerts"

    dimensions = {
        "ClusterName" = ""
        "PodName"     = ""
        "Namespace"   = ""
    }
    # Slack information
    slack_hook_url = ""
    slack_channel  = ""
    slack_username = ""

    #Opsgenie integration url
    opsgenie_endpoint = [""]
}
```

# Example 2

In this case, you can create alarm to override default parameters.

```
module "cloudwatchalarm" {
    source           = "dasmeta/modules/aws//modules/cloudwatch-alarm-notify"
    alarm_name       = "alarmname"

    # Type  k8s_alerts, alb_alerts
    alert_type_name  = "alb_alerts"
    threshold        = "50"

    # Slack information
    slack_hook_url   = ""
    slack_channel    = ""
    slack_username   = ""

    #Opsgenie integration url
    opsgenie_endpoint = [""]
}
```

# Example 3

This case you can create alarm not implemented case.

```
module "cloudwatchalarm" {
    source           = "dasmeta/modules/aws//modules/cloudwatch-alarm-notify"
    alarm_name       = "alarmname"


    # Variables
    comparison_operator    = "GreaterThanOrEqualToThreshold"
    evaluation_periods     = "1"
    period                 = "300"
    namespace              = "ContainerInsights"
    unit                   = "Percent"
    metric_name            = "pod_cpu_utilization"
    statistic              = "Average"
    threshold              = "50"
    treat_missing_data     = "notBreaching"
    dimensions             = {}
    insufficient_data_actions = []

    # Slack information
    slack_hook_url   = ""
    slack_channel    = ""
    slack_username   = ""

    #Opsgenie integration url
    opsgenie_endpoint = [""]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

| Name                                                                    | Source                                 | Version |
| ----------------------------------------------------------------------- | -------------------------------------- | ------- |
| <a name="module_notify_slack"></a> [notify_slack](#module_notify_slack) | terraform-aws-modules/notify-slack/aws | 4.18.0  |

## Resources

| Name                                                                                                                                                 | Type     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_cloudwatch_metric_alarm.metric-alarm-down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.metric-alarm-up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm)   | resource |
| [aws_sns_topic.k8s-alerts-notify-email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)                       | resource |
| [aws_sns_topic.k8s-alerts-notify-opsgenie](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)                    | resource |
| [aws_sns_topic.k8s-alerts-notify-sms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)                         | resource |
| [aws_sns_topic_subscription.email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription)               | resource |
| [aws_sns_topic_subscription.opsgenie](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription)            | resource |
| [aws_sns_topic_subscription.sms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription)                 | resource |

## Inputs

| Name                                                                                                                                                | Description                                                                         | Type           | Default              | Required |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | -------------- | -------------------- | :------: |
| <a name="input_alarm_actions"></a> [alarm_actions](#input_alarm_actions)                                                                            | n/a                                                                                 | `list(string)` | `[]`                 |    no    |
| <a name="input_alarm_description"></a> [alarm_description](#input_alarm_description)                                                                | n/a                                                                                 | `string`       | `""`                 |    no    |
| <a name="input_alarm_name"></a> [alarm_name](#input_alarm_name)                                                                                     | Domain name or ip address of checking service.                                      | `string`       | n/a                  |   yes    |
| <a name="input_alert_type_name"></a> [alert_type_name](#input_alert_type_name)                                                                      | Alert_Type                                                                          | `string`       | `"other"`            |    no    |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch_log_group_retention_in_days](#input_cloudwatch_log_group_retention_in_days) | Specifies the number of days you want to retain log events in log group for Lambda. | `number`       | `0`                  |    no    |
| <a name="input_comparison_operator"></a> [comparison_operator](#input_comparison_operator)                                                          | Comparison operator.                                                                | `string`       | `""`                 |    no    |
| <a name="input_dimensions"></a> [dimensions](#input_dimensions)                                                                                     | n/a                                                                                 | `map(any)`     | `{}`                 |    no    |
| <a name="input_evaluation_periods"></a> [evaluation_periods](#input_evaluation_periods)                                                             | Evaluation periods.                                                                 | `string`       | `""`                 |    no    |
| <a name="input_insufficient_data_actions"></a> [insufficient_data_actions](#input_insufficient_data_actions)                                        | n/a                                                                                 | `list(any)`    | `[]`                 |    no    |
| <a name="input_metric_name"></a> [metric_name](#input_metric_name)                                                                                  | Name of the metric.                                                                 | `string`       | `""`                 |    no    |
| <a name="input_namespace"></a> [namespace](#input_namespace)                                                                                        | Alarm emitter.                                                                      | `string`       | `""`                 |    no    |
| <a name="input_opsgenie_endpoint"></a> [opsgenie_endpoint](#input_opsgenie_endpoint)                                                                | Opsigenie platform integration url                                                  | `list(string)` | `[]`                 |    no    |
| <a name="input_period"></a> [period](#input_period)                                                                                                 | Period.                                                                             | `string`       | `""`                 |    no    |
| <a name="input_slack_channel"></a> [slack_channel](#input_slack_channel)                                                                            | Slack Channel                                                                       | `string`       | `""`                 |    no    |
| <a name="input_slack_hook_url"></a> [slack_hook_url](#input_slack_hook_url)                                                                         | This is slack webhook url path without domain                                       | `string`       | `""`                 |    no    |
| <a name="input_slack_username"></a> [slack_username](#input_slack_username)                                                                         | Slack User Name                                                                     | `string`       | `""`                 |    no    |
| <a name="input_sms_message_body"></a> [sms_message_body](#input_sms_message_body)                                                                   | n/a                                                                                 | `string`       | `"sms_message_body"` |    no    |
| <a name="input_sns_subscription_email_address_list"></a> [sns_subscription_email_address_list](#input_sns_subscription_email_address_list)          | List of email addresses                                                             | `list(string)` | `[]`                 |    no    |
| <a name="input_sns_subscription_phone_number_list"></a> [sns_subscription_phone_number_list](#input_sns_subscription_phone_number_list)             | List of telephone numbers to subscribe to SNS.                                      | `list(string)` | `[]`                 |    no    |
| <a name="input_statistic"></a> [statistic](#input_statistic)                                                                                        | Statistic.                                                                          | `string`       | `""`                 |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                                       | Tags object.                                                                        | `map`          | `{}`                 |    no    |
| <a name="input_threshold"></a> [threshold](#input_threshold)                                                                                        | Threshold.                                                                          | `string`       | `""`                 |    no    |
| <a name="input_treat_missing_data"></a> [treat_missing_data](#input_treat_missing_data)                                                             | n/a                                                                                 | `string`       | `""`                 |    no    |
| <a name="input_unit"></a> [unit](#input_unit)                                                                                                       | n/a                                                                                 | `string`       | `""`                 |    no    |

## Outputs

| Name                                                                 | Description |
| -------------------------------------------------------------------- | ----------- |
| <a name="output_metric_name"></a> [metric_name](#output_metric_name) | n/a         |
| <a name="output_namespace"></a> [namespace](#output_namespace)       | n/a         |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
