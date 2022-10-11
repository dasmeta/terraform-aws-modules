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

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.50.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.50.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_notify_slack"></a> [notify\_slack](#module\_notify\_slack) | terraform-aws-modules/notify-slack/aws | 4.18.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.metric-alarm-down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.metric-alarm-up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_route53_health_check.healthcheck](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check) | resource |
| [aws_sns_topic.this-email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic.this-opsgenie](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic.this-sms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.opsgenie](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.sms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic.aws_sns_topic_slack_health_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sns_topic) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | n/a | `list(string)` | `[]` | no |
| <a name="input_alarm_description_down"></a> [alarm\_description\_down](#input\_alarm\_description\_down) | n/a | `string` | `"This metric monitors whether the service endpoint is down or not."` | no |
| <a name="input_alarm_description_up"></a> [alarm\_description\_up](#input\_alarm\_description\_up) | n/a | `string` | `"This metric monitors whether the service endpoint is up"` | no |
| <a name="input_alarm_region"></a> [alarm\_region](#input\_alarm\_region) | Region from where the alarms must be monitored. All regions are taken if the value is omited. | `string` | `"eu-central-1"` | no |
| <a name="input_comparison_operator"></a> [comparison\_operator](#input\_comparison\_operator) | Comparison operator. | `string` | `"LessThanThreshold"` | no |
| <a name="input_depends"></a> [depends](#input\_depends) | n/a | `list` | `[]` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | n/a | `map` | `{}` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name or ip address of checking service. | `string` | n/a | yes |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | Evaluation periods. | `string` | `"1"` | no |
| <a name="input_failure_threshold"></a> [failure\_threshold](#input\_failure\_threshold) | The number of consecutive health checks that an endpoint must pass or fail. | `string` | `"5"` | no |
| <a name="input_measure_latency"></a> [measure\_latency](#input\_measure\_latency) | (Optional) A Boolean value that indicates whether you want Route 53 to measure the latency between health checkers in multiple AWS regions and your endpoint and to display CloudWatch latency graphs in the Route 53 console. | `bool` | `false` | no |
| <a name="input_metric_name"></a> [metric\_name](#input\_metric\_name) | Name of the metric. | `string` | `"HealthCheckStatus"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Alarm emitter. | `string` | `"AWS/Route53"` | no |
| <a name="input_opsgenie_endpoint"></a> [opsgenie\_endpoint](#input\_opsgenie\_endpoint) | Opsigenie platform integration url | `list(string)` | `[]` | no |
| <a name="input_period"></a> [period](#input\_period) | Period. | `string` | `"60"` | no |
| <a name="input_port"></a> [port](#input\_port) | Port number of checking service. | `number` | `443` | no |
| <a name="input_reference_name"></a> [reference\_name](#input\_reference\_name) | Reference name of health check. | `string` | `""` | no |
| <a name="input_regions"></a> [regions](#input\_regions) | (Optional) A list of AWS regions that you want Amazon Route 53 health checkers to check the specified endpoint from. | `list(string)` | <pre>[<br>  "us-east-1",<br>  "eu-west-1",<br>  "ap-northeast-1"<br>]</pre> | no |
| <a name="input_request_interval"></a> [request\_interval](#input\_request\_interval) | The number of seconds between the time that Amazon Route 53 gets a response from your endpoint and the time that it sends the next health-check request. | `string` | `"30"` | no |
| <a name="input_resource_path"></a> [resource\_path](#input\_resource\_path) | Path name coming after fqdn. | `string` | `""` | no |
| <a name="input_slack_channel"></a> [slack\_channel](#input\_slack\_channel) | Slack Channel | `string` | `null` | no |
| <a name="input_slack_hook_url"></a> [slack\_hook\_url](#input\_slack\_hook\_url) | This is slack webhook url path without domain | `string` | `null` | no |
| <a name="input_slack_username"></a> [slack\_username](#input\_slack\_username) | Slack User Name | `string` | `null` | no |
| <a name="input_sms_message_body"></a> [sms\_message\_body](#input\_sms\_message\_body) | n/a | `string` | `"sms_message_body"` | no |
| <a name="input_sns_subscription_email_address_list"></a> [sns\_subscription\_email\_address\_list](#input\_sns\_subscription\_email\_address\_list) | List of email addresses | `list(string)` | `[]` | no |
| <a name="input_sns_subscription_phone_number_list"></a> [sns\_subscription\_phone\_number\_list](#input\_sns\_subscription\_phone\_number\_list) | List of telephone numbers to subscribe to SNS. | `list(string)` | `[]` | no |
| <a name="input_statistic"></a> [statistic](#input\_statistic) | Statistic. | `string` | `"Minimum"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags object. | `map` | `{}` | no |
| <a name="input_threshold"></a> [threshold](#input\_threshold) | Threshold. | `string` | `"1"` | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | SNS topic name. | `string` | `"topic"` | no |
| <a name="input_treat_missing_data"></a> [treat\_missing\_data](#input\_treat\_missing\_data) | n/a | `string` | `"breaching"` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of health check. | `string` | `"HTTPS"` | no |
| <a name="input_unit"></a> [unit](#input\_unit) | n/a | `string` | `"None"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
