## use sample

```hcl

module "healthcheck" {
  providers = {
    aws = aws.virginia
  }

  source                              = "dasmeta/modules/aws//modules/route53-alerts-notify"
  version                             = "0.16.6"

  domain_name                         = "devops.dasmeta.com"
  resource_path                       = "/"
  type                                = "HTTPS"
  port                                = "443"
  measure_latency                     = true
  regions                             = ["us-east-1","eu-west-1","ap-northeast-1"]
  slack_hook_url                      = "{SLACK_WEBHOOK_PATH_VALUE}"
  slack_username                      = "{SLACK_USERNAME_VALUE}"
  slack_channel                       = "{SLACK_CHANNEL_NAME_VALUE}"
  sns_subscription_email_address_list = ["info@example.com"]
  sns_subscription_phone_number_list  = ["+0000000000"]
  tags = {
    Name = "{HEALTH_CHECK_NAME_VALUE}"
  }
}


```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                   | Version   |
| ------------------------------------------------------ | --------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | >= 2.50.0 |

## Providers

| Name                                             | Version   |
| ------------------------------------------------ | --------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 2.50.0 |

## Modules

| Name                                                                    | Source                                 | Version |
| ----------------------------------------------------------------------- | -------------------------------------- | ------- |
| <a name="module_notify_slack"></a> [notify_slack](#module_notify_slack) | terraform-aws-modules/notify-slack/aws | 4.18.0  |

## Resources

| Name                                                                                                                                                 | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudwatch_metric_alarm.metric-alarm-down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource    |
| [aws_cloudwatch_metric_alarm.metric-alarm-up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm)   | resource    |
| [aws_route53_health_check.healthcheck](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check)             | resource    |
| [aws_sns_topic.this-email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)                                    | resource    |
| [aws_sns_topic.this-opsgenie](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)                                 | resource    |
| [aws_sns_topic.this-sms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)                                      | resource    |
| [aws_sns_topic_subscription.email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription)               | resource    |
| [aws_sns_topic_subscription.opsgenie](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription)            | resource    |
| [aws_sns_topic_subscription.sms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription)                 | resource    |
| [aws_sns_topic.aws_sns_topic_slack_health_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sns_topic)           | data source |

## Inputs

| Name                                                                                                                                       | Description                                                                                                                                                                                                                    | Type           | Default                                                                  | Required |
| ------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------- | ------------------------------------------------------------------------ | :------: |
| <a name="input_alarm_actions"></a> [alarm_actions](#input_alarm_actions)                                                                   | n/a                                                                                                                                                                                                                            | `list(string)` | `[]`                                                                     |    no    |
| <a name="input_alarm_description_down"></a> [alarm_description_down](#input_alarm_description_down)                                        | n/a                                                                                                                                                                                                                            | `string`       | `"This metric monitors whether the service endpoint is down or not."`    |    no    |
| <a name="input_alarm_description_up"></a> [alarm_description_up](#input_alarm_description_up)                                              | n/a                                                                                                                                                                                                                            | `string`       | `"This metric monitors whether the service endpoint is up"`              |    no    |
| <a name="input_alarm_region"></a> [alarm_region](#input_alarm_region)                                                                      | Region from where the alarms must be monitored. All regions are taken if the value is omited.                                                                                                                                  | `string`       | `"eu-central-1"`                                                         |    no    |
| <a name="input_comparison_operator"></a> [comparison_operator](#input_comparison_operator)                                                 | Comparison operator.                                                                                                                                                                                                           | `string`       | `"LessThanThreshold"`                                                    |    no    |
| <a name="input_depends"></a> [depends](#input_depends)                                                                                     | n/a                                                                                                                                                                                                                            | `list`         | `[]`                                                                     |    no    |
| <a name="input_dimensions"></a> [dimensions](#input_dimensions)                                                                            | n/a                                                                                                                                                                                                                            | `map`          | `{}`                                                                     |    no    |
| <a name="input_domain_name"></a> [domain_name](#input_domain_name)                                                                         | Domain name or ip address of checking service.                                                                                                                                                                                 | `string`       | n/a                                                                      |   yes    |
| <a name="input_evaluation_periods"></a> [evaluation_periods](#input_evaluation_periods)                                                    | Evaluation periods.                                                                                                                                                                                                            | `string`       | `"1"`                                                                    |    no    |
| <a name="input_failure_threshold"></a> [failure_threshold](#input_failure_threshold)                                                       | The number of consecutive health checks that an endpoint must pass or fail.                                                                                                                                                    | `string`       | `"5"`                                                                    |    no    |
| <a name="input_measure_latency"></a> [measure_latency](#input_measure_latency)                                                             | (Optional) A Boolean value that indicates whether you want Route 53 to measure the latency between health checkers in multiple AWS regions and your endpoint and to display CloudWatch latency graphs in the Route 53 console. | `bool`         | `false`                                                                  |    no    |
| <a name="input_metric_name"></a> [metric_name](#input_metric_name)                                                                         | Name of the metric.                                                                                                                                                                                                            | `string`       | `"HealthCheckStatus"`                                                    |    no    |
| <a name="input_namespace"></a> [namespace](#input_namespace)                                                                               | Alarm emitter.                                                                                                                                                                                                                 | `string`       | `"AWS/Route53"`                                                          |    no    |
| <a name="input_opsgenie_endpoint"></a> [opsgenie_endpoint](#input_opsgenie_endpoint)                                                       | Opsigenie platform integration url                                                                                                                                                                                             | `list(string)` | `[]`                                                                     |    no    |
| <a name="input_period"></a> [period](#input_period)                                                                                        | Period.                                                                                                                                                                                                                        | `string`       | `"60"`                                                                   |    no    |
| <a name="input_port"></a> [port](#input_port)                                                                                              | Port number of checking service.                                                                                                                                                                                               | `number`       | `443`                                                                    |    no    |
| <a name="input_reference_name"></a> [reference_name](#input_reference_name)                                                                | Reference name of health check.                                                                                                                                                                                                | `string`       | `""`                                                                     |    no    |
| <a name="input_regions"></a> [regions](#input_regions)                                                                                     | (Optional) A list of AWS regions that you want Amazon Route 53 health checkers to check the specified endpoint from.                                                                                                           | `list(string)` | <pre>[<br> "us-east-1",<br> "eu-west-1",<br> "ap-northeast-1"<br>]</pre> |    no    |
| <a name="input_request_interval"></a> [request_interval](#input_request_interval)                                                          | The number of seconds between the time that Amazon Route 53 gets a response from your endpoint and the time that it sends the next health-check request.                                                                       | `string`       | `"30"`                                                                   |    no    |
| <a name="input_resource_path"></a> [resource_path](#input_resource_path)                                                                   | Path name coming after fqdn.                                                                                                                                                                                                   | `string`       | `""`                                                                     |    no    |
| <a name="input_slack_channel"></a> [slack_channel](#input_slack_channel)                                                                   | Slack Channel                                                                                                                                                                                                                  | `string`       | n/a                                                                      |   yes    |
| <a name="input_slack_hook_url"></a> [slack_hook_url](#input_slack_hook_url)                                                                | This is slack webhook url path without domain                                                                                                                                                                                  | `string`       | n/a                                                                      |   yes    |
| <a name="input_slack_username"></a> [slack_username](#input_slack_username)                                                                | Slack User Name                                                                                                                                                                                                                | `string`       | n/a                                                                      |   yes    |
| <a name="input_sms_message_body"></a> [sms_message_body](#input_sms_message_body)                                                          | n/a                                                                                                                                                                                                                            | `string`       | `"sms_message_body"`                                                     |    no    |
| <a name="input_sns_subscription_email_address_list"></a> [sns_subscription_email_address_list](#input_sns_subscription_email_address_list) | List of email addresses                                                                                                                                                                                                        | `list(string)` | `[]`                                                                     |    no    |
| <a name="input_sns_subscription_phone_number_list"></a> [sns_subscription_phone_number_list](#input_sns_subscription_phone_number_list)    | List of telephone numbers to subscribe to SNS.                                                                                                                                                                                 | `list(string)` | `[]`                                                                     |    no    |
| <a name="input_statistic"></a> [statistic](#input_statistic)                                                                               | Statistic.                                                                                                                                                                                                                     | `string`       | `"Minimum"`                                                              |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                              | Tags object.                                                                                                                                                                                                                   | `map`          | `{}`                                                                     |    no    |
| <a name="input_threshold"></a> [threshold](#input_threshold)                                                                               | Threshold.                                                                                                                                                                                                                     | `string`       | `"1"`                                                                    |    no    |
| <a name="input_topic_name"></a> [topic_name](#input_topic_name)                                                                            | SNS topic name.                                                                                                                                                                                                                | `string`       | `"topic"`                                                                |    no    |
| <a name="input_treat_missing_data"></a> [treat_missing_data](#input_treat_missing_data)                                                    | n/a                                                                                                                                                                                                                            | `string`       | `"breaching"`                                                            |    no    |
| <a name="input_type"></a> [type](#input_type)                                                                                              | Type of health check.                                                                                                                                                                                                          | `string`       | `"HTTPS"`                                                                |    no    |
| <a name="input_unit"></a> [unit](#input_unit)                                                                                              | n/a                                                                                                                                                                                                                            | `string`       | `"None"`                                                                 |    no    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
