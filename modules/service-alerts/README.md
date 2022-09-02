# Module Use Case

## Case 1

```
module "cloudwatchalarm" {
    source  = "dasmeta/modules/aws//modules/service-alerts"

    env = "stage-pod"
    cluster_name = "eks-cluster-name"
    pod_name     = "eks-pod-name"
    namespace    = "eks-pod-namespace"

    log_group_name  = "/aws/example/"
    create_dashboard = true

    sns_subscription_email_address_list = ["devops@domain.com"]
}
```

## Case 2

```
module "cloudwatchalarm" {
    source  = "dasmeta/modules/aws//modules/service-alerts"

    env = "stage-pod"
    cluster_name = "eks-cluster-name"
    pod_name     = "eks-pod-name"
    namespace    = "eks-pod-namespace"

    cpu_threshold = "50"
    memory_threshold = "50"
    network_threshold = "1000"
    restart_threshold   = "10"

    error_threshold = "10"
    log_group_name  = "/aws/example/"

//  You can disable alarms, default all is true
    enable_error_filter  = false
    enable_cpu_threshold = false
    enable_memory_threshold  = false
    enable_network_threshold = false
    enable_restart_threshold = false

    create_dashboard = true

    sns_subscription_email_address_list = ["devops@domain.com"]
}
```

## Case 3

```
module "cloudwatchalarm" {
    source  = "dasmeta/modules/aws//modules/service-alerts"

    env = "stage-pod"
    cluster_name = "eks-cluster-name"
    pod_name     = "eks-pod-name"
    namespace    = "eks-pod-namespace"

    cpu_threshold = "50"
    cpu_unit      = "Percent"
    cpu_period    = "cpu_period"
    cpu_statistic = "Average"


    memory_threshold = "50"
    memory_unit      = "Percent"
    memory_period    = "300"
    memory_statistic = "Average"


    network_threshold = "1000"
    network_unit      = "Percent"
    network_period    = "300"
    network_statistic = "Average"

    restart_threshold   = "1"
    restart_unit    = "Count"
    restart_period  = "60"
    restart_statistic = "Maximum"

    error_threshold = "10"
    error_unit      = "Percent"
    error_period    = "3600"
    error_statistic = "Sum"

    log_group_name  = "/aws/example/"

//  You can disable alarms, default all is true
    enable_error_filter  = false
    enable_cpu_threshold = false
    enable_memory_threshold  = false
    enable_network_threshold = false
    enable_restart_threshold = false

    create_dashboard = true
    dashboard_region = "us-east-1"

    sns_subscription_email_address_list = ["devops@domain.com"]
    sns_subscription_phone_number_list  = []
    sms_message_body = ""

    slack_hook_url = ""
    slack_channel  = ""
    slack_username = ""
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

| Name                                                                                                                       | Source                     | Version |
| -------------------------------------------------------------------------------------------------------------------------- | -------------------------- | ------- |
| <a name="module_cloudwatch_log_metric_filter"></a> [cloudwatch_log_metric_filter](#module_cloudwatch_log_metric_filter)    | ../cloudwatch-log-metric   | n/a     |
| <a name="module_cloudwatchalarm_cpu"></a> [cloudwatchalarm_cpu](#module_cloudwatchalarm_cpu)                               | ../cloudwatch-alarm-notify | n/a     |
| <a name="module_cloudwatchalarm_error"></a> [cloudwatchalarm_error](#module_cloudwatchalarm_error)                         | ../cloudwatch-alarm-notify | n/a     |
| <a name="module_cloudwatchalarm_memory"></a> [cloudwatchalarm_memory](#module_cloudwatchalarm_memory)                      | ../cloudwatch-alarm-notify | n/a     |
| <a name="module_cloudwatchalarm_network_rx"></a> [cloudwatchalarm_network_rx](#module_cloudwatchalarm_network_rx)          | ../cloudwatch-alarm-notify | n/a     |
| <a name="module_cloudwatchalarm_network_tx"></a> [cloudwatchalarm_network_tx](#module_cloudwatchalarm_network_tx)          | ../cloudwatch-alarm-notify | n/a     |
| <a name="module_cloudwatchalarm_restart_count"></a> [cloudwatchalarm_restart_count](#module_cloudwatchalarm_restart_count) | ../cloudwatch-alarm-notify | n/a     |

## Resources

| Name                                                                                                                                               | Type     |
| -------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_cloudwatch_dashboard.error_metric_include2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |

## Inputs

| Name                                                                                                                                                | Description                                                                         | Type           | Default              | Required |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | -------------- | -------------------- | :------: |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch_log_group_retention_in_days](#input_cloudwatch_log_group_retention_in_days) | Specifies the number of days you want to retain log events in log group for Lambda. | `number`       | `0`                  |    no    |
| <a name="input_cluster_name"></a> [cluster_name](#input_cluster_name)                                                                               | Cluser Name                                                                         | `string`       | n/a                  |   yes    |
| <a name="input_cpu_period"></a> [cpu_period](#input_cpu_period)                                                                                     | CPU Period                                                                          | `string`       | `"300"`              |    no    |
| <a name="input_cpu_statistic"></a> [cpu_statistic](#input_cpu_statistic)                                                                            | CPU Statistic                                                                       | `string`       | `"Average"`          |    no    |
| <a name="input_cpu_threshold"></a> [cpu_threshold](#input_cpu_threshold)                                                                            | CPU Trashold                                                                        | `string`       | `"50"`               |    no    |
| <a name="input_cpu_unit"></a> [cpu_unit](#input_cpu_unit)                                                                                           | CPU Unit                                                                            | `string`       | `"Percent"`          |    no    |
| <a name="input_create_dashboard"></a> [create_dashboard](#input_create_dashboard)                                                                   | If you create dashboard input yes otherwise no                                      | `bool`         | `true`               |    no    |
| <a name="input_dashboard_region"></a> [dashboard_region](#input_dashboard_region)                                                                   | If you create dashboard input yes otherwise no                                      | `string`       | `"us-east-1"`        |    no    |
| <a name="input_enable_cpu_threshold"></a> [enable_cpu_threshold](#input_enable_cpu_threshold)                                                       | Enable cpu threshold or no                                                          | `bool`         | `true`               |    no    |
| <a name="input_enable_error_filter"></a> [enable_error_filter](#input_enable_error_filter)                                                          | Enable error log or no                                                              | `bool`         | `true`               |    no    |
| <a name="input_enable_memory_threshold"></a> [enable_memory_threshold](#input_enable_memory_threshold)                                              | Enable memory threshold or no                                                       | `bool`         | `true`               |    no    |
| <a name="input_enable_network_threshold"></a> [enable_network_threshold](#input_enable_network_threshold)                                           | Enable network threshold or no                                                      | `bool`         | `true`               |    no    |
| <a name="input_enable_restart_threshold"></a> [enable_restart_threshold](#input_enable_restart_threshold)                                           | Enable restart threshold or no                                                      | `bool`         | `true`               |    no    |
| <a name="input_env"></a> [env](#input_env)                                                                                                          | Environment Name                                                                    | `string`       | `""`                 |    no    |
| <a name="input_error_filter_pattern"></a> [error_filter_pattern](#input_error_filter_pattern)                                                       | Log group error filter pattern                                                      | `string`       | `"Error"`            |    no    |
| <a name="input_error_period"></a> [error_period](#input_error_period)                                                                               | Error Period                                                                        | `string`       | `"3600"`             |    no    |
| <a name="input_error_statistic"></a> [error_statistic](#input_error_statistic)                                                                      | Error Statistic                                                                     | `string`       | `"Sum"`              |    no    |
| <a name="input_error_threshold"></a> [error_threshold](#input_error_threshold)                                                                      | Error threshold                                                                     | `string`       | `"10"`               |    no    |
| <a name="input_error_unit"></a> [error_unit](#input_error_unit)                                                                                     | Error Unit                                                                          | `string`       | `"Percent"`          |    no    |
| <a name="input_log_group_name"></a> [log_group_name](#input_log_group_name)                                                                         | Metric filter create in log group.                                                  | `string`       | `""`                 |    no    |
| <a name="input_memory_period"></a> [memory_period](#input_memory_period)                                                                            | Memory Period                                                                       | `string`       | `"300"`              |    no    |
| <a name="input_memory_statistic"></a> [memory_statistic](#input_memory_statistic)                                                                   | Memory Statistic                                                                    | `string`       | `"Average"`          |    no    |
| <a name="input_memory_threshold"></a> [memory_threshold](#input_memory_threshold)                                                                   | Memory Trashold                                                                     | `string`       | `"50"`               |    no    |
| <a name="input_memory_unit"></a> [memory_unit](#input_memory_unit)                                                                                  | Memory Unit                                                                         | `string`       | `"Percent"`          |    no    |
| <a name="input_namespace"></a> [namespace](#input_namespace)                                                                                        | Pod Namespace                                                                       | `string`       | n/a                  |   yes    |
| <a name="input_network_period"></a> [network_period](#input_network_period)                                                                         | Network Period                                                                      | `string`       | `"300"`              |    no    |
| <a name="input_network_statistic"></a> [network_statistic](#input_network_statistic)                                                                | Network Statistic                                                                   | `string`       | `"Average"`          |    no    |
| <a name="input_network_threshold"></a> [network_threshold](#input_network_threshold)                                                                | Networ Threshold                                                                    | `string`       | `"5000"`             |    no    |
| <a name="input_network_unit"></a> [network_unit](#input_network_unit)                                                                               | Network Unit                                                                        | `string`       | `"Bytes/Second"`     |    no    |
| <a name="input_opsgenie_endpoints"></a> [opsgenie_endpoints](#input_opsgenie_endpoints)                                                             | Opsigenie platform integration url                                                  | `list(string)` | `[]`                 |    no    |
| <a name="input_pod_name"></a> [pod_name](#input_pod_name)                                                                                           | Pod Name                                                                            | `string`       | n/a                  |   yes    |
| <a name="input_restart_period"></a> [restart_period](#input_restart_period)                                                                         | Restart Period                                                                      | `string`       | `"60"`               |    no    |
| <a name="input_restart_statistic"></a> [restart_statistic](#input_restart_statistic)                                                                | Restart Statistic                                                                   | `string`       | `"Maximum"`          |    no    |
| <a name="input_restart_threshold"></a> [restart_threshold](#input_restart_threshold)                                                                | Restart Count                                                                       | `string`       | `"1"`                |    no    |
| <a name="input_restart_unit"></a> [restart_unit](#input_restart_unit)                                                                               | Restart Unit                                                                        | `string`       | `"Count"`            |    no    |
| <a name="input_slack_channel"></a> [slack_channel](#input_slack_channel)                                                                            | Slack Channel                                                                       | `string`       | `""`                 |    no    |
| <a name="input_slack_hook_url"></a> [slack_hook_url](#input_slack_hook_url)                                                                         | This is slack webhook url path without domain                                       | `string`       | `""`                 |    no    |
| <a name="input_slack_username"></a> [slack_username](#input_slack_username)                                                                         | Slack User Name                                                                     | `string`       | `""`                 |    no    |
| <a name="input_sms_message_body"></a> [sms_message_body](#input_sms_message_body)                                                                   | n/a                                                                                 | `string`       | `"sms_message_body"` |    no    |
| <a name="input_sns_subscription_email_address_list"></a> [sns_subscription_email_address_list](#input_sns_subscription_email_address_list)          | List of email addresses                                                             | `list(string)` | `[]`                 |    no    |
| <a name="input_sns_subscription_phone_number_list"></a> [sns_subscription_phone_number_list](#input_sns_subscription_phone_number_list)             | List of telephone numbers to subscribe to SNS.                                      | `list(string)` | `[]`                 |    no    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
