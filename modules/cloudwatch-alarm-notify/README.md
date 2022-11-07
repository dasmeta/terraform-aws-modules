Module use examples.

# Example 1

In this case, you can create alarm default parameters using only alert type.

```
module "cloudwatchalarm" {
    source           = "dasmeta/modules/aws//modules/cloudwatch-alarm-notify"
    alarm_name       = "alarmname"
    # Type  k8s_alerts, alb_alerts,rds_alerts,other
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

    # Type  k8s_alerts, alb_alerts,rds_alerts,other
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

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_notify_slack"></a> [notify\_slack](#module\_notify\_slack) | terraform-aws-modules/notify-slack/aws | 4.18.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.metric-alarm-down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.metric-alarm-up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sns_topic.k8s-alerts-notify-email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic.k8s-alerts-notify-opsgenie](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic.k8s-alerts-notify-sms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.opsgenie](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.sms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | n/a | `list(string)` | `[]` | no |
| <a name="input_alarm_description"></a> [alarm\_description](#input\_alarm\_description) | n/a | `string` | `""` | no |
| <a name="input_alarm_name"></a> [alarm\_name](#input\_alarm\_name) | Domain name or ip address of checking service. | `string` | n/a | yes |
| <a name="input_alarm_prefix_down"></a> [alarm\_prefix\_down](#input\_alarm\_prefix\_down) | A prefix for the alarm message when the host is down. The default is a slack emoji. | `string` | `":x: "` | no |
| <a name="input_alarm_prefix_up"></a> [alarm\_prefix\_up](#input\_alarm\_prefix\_up) | A prefix for the alarm message when the host is up. The default is a slack emoji. | `string` | `":white_check_mark: "` | no |
| <a name="input_alert_type_name"></a> [alert\_type\_name](#input\_alert\_type\_name) | Alert\_Type | `string` | `"other"` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in log group for Lambda. | `number` | `0` | no |
| <a name="input_comparison_operator"></a> [comparison\_operator](#input\_comparison\_operator) | Comparison operator. | `string` | `""` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | n/a | `map(any)` | `{}` | no |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | Evaluation periods. | `string` | `""` | no |
| <a name="input_insufficient_data_actions"></a> [insufficient\_data\_actions](#input\_insufficient\_data\_actions) | n/a | `list(any)` | `[]` | no |
| <a name="input_metric_name"></a> [metric\_name](#input\_metric\_name) | Name of the metric. | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Alarm emitter. | `string` | `""` | no |
| <a name="input_opsgenie_endpoint"></a> [opsgenie\_endpoint](#input\_opsgenie\_endpoint) | Opsigenie platform integration url | `list(string)` | `[]` | no |
| <a name="input_period"></a> [period](#input\_period) | Period. | `string` | `""` | no |
| <a name="input_slack_channel"></a> [slack\_channel](#input\_slack\_channel) | Slack Channel | `string` | `""` | no |
| <a name="input_slack_hook_url"></a> [slack\_hook\_url](#input\_slack\_hook\_url) | This is slack webhook url path without domain | `string` | `""` | no |
| <a name="input_slack_username"></a> [slack\_username](#input\_slack\_username) | Slack User Name | `string` | `""` | no |
| <a name="input_sms_message_body"></a> [sms\_message\_body](#input\_sms\_message\_body) | n/a | `string` | `"sms_message_body"` | no |
| <a name="input_sns_subscription_email_address_list"></a> [sns\_subscription\_email\_address\_list](#input\_sns\_subscription\_email\_address\_list) | List of email addresses | `list(string)` | `[]` | no |
| <a name="input_sns_subscription_phone_number_list"></a> [sns\_subscription\_phone\_number\_list](#input\_sns\_subscription\_phone\_number\_list) | List of telephone numbers to subscribe to SNS. | `list(string)` | `[]` | no |
| <a name="input_sns_topic_arn"></a> [sns\_topic\_arn](#input\_sns\_topic\_arn) | The ARN of an SNS topic to which notifications will be sent. This does not relate to the other SNS topic variables. | `string` | `null` | no |
| <a name="input_statistic"></a> [statistic](#input\_statistic) | Statistic. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags object. | `map` | `{}` | no |
| <a name="input_threshold"></a> [threshold](#input\_threshold) | Threshold. | `string` | `""` | no |
| <a name="input_treat_missing_data"></a> [treat\_missing\_data](#input\_treat\_missing\_data) | n/a | `string` | `""` | no |
| <a name="input_unit"></a> [unit](#input\_unit) | n/a | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_metric_name"></a> [metric\_name](#output\_metric\_name) | n/a |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
