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

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudwatch_log_metric_filter"></a> [cloudwatch\_log\_metric\_filter](#module\_cloudwatch\_log\_metric\_filter) | ../cloudwatch-log-metric | n/a |
| <a name="module_cloudwatchalarm_cpu"></a> [cloudwatchalarm\_cpu](#module\_cloudwatchalarm\_cpu) | ../cloudwatch-alarm-notify | n/a |
| <a name="module_cloudwatchalarm_error"></a> [cloudwatchalarm\_error](#module\_cloudwatchalarm\_error) | ../cloudwatch-alarm-notify | n/a |
| <a name="module_cloudwatchalarm_memory"></a> [cloudwatchalarm\_memory](#module\_cloudwatchalarm\_memory) | ../cloudwatch-alarm-notify | n/a |
| <a name="module_cloudwatchalarm_network_rx"></a> [cloudwatchalarm\_network\_rx](#module\_cloudwatchalarm\_network\_rx) | ../cloudwatch-alarm-notify | n/a |
| <a name="module_cloudwatchalarm_network_tx"></a> [cloudwatchalarm\_network\_tx](#module\_cloudwatchalarm\_network\_tx) | ../cloudwatch-alarm-notify | n/a |
| <a name="module_cloudwatchalarm_restart_count"></a> [cloudwatchalarm\_restart\_count](#module\_cloudwatchalarm\_restart\_count) | ../cloudwatch-alarm-notify | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_dashboard.error_metric_include2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in log group for Lambda. | `number` | `0` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Cluser Name | `string` | n/a | yes |
| <a name="input_cpu_period"></a> [cpu\_period](#input\_cpu\_period) | CPU Period | `string` | `"300"` | no |
| <a name="input_cpu_statistic"></a> [cpu\_statistic](#input\_cpu\_statistic) | CPU Statistic | `string` | `"Average"` | no |
| <a name="input_cpu_threshold"></a> [cpu\_threshold](#input\_cpu\_threshold) | CPU Trashold | `string` | `"50"` | no |
| <a name="input_cpu_unit"></a> [cpu\_unit](#input\_cpu\_unit) | CPU Unit | `string` | `"Percent"` | no |
| <a name="input_create_dashboard"></a> [create\_dashboard](#input\_create\_dashboard) | If you create dashboard input yes otherwise no | `bool` | `true` | no |
| <a name="input_dashboard_region"></a> [dashboard\_region](#input\_dashboard\_region) | If you create dashboard input yes otherwise no | `string` | `"us-east-1"` | no |
| <a name="input_enable_cpu_threshold"></a> [enable\_cpu\_threshold](#input\_enable\_cpu\_threshold) | Enable cpu threshold or no | `bool` | `true` | no |
| <a name="input_enable_error_filter"></a> [enable\_error\_filter](#input\_enable\_error\_filter) | Enable error log or no | `bool` | `true` | no |
| <a name="input_enable_memory_threshold"></a> [enable\_memory\_threshold](#input\_enable\_memory\_threshold) | Enable memory threshold or no | `bool` | `true` | no |
| <a name="input_enable_network_threshold"></a> [enable\_network\_threshold](#input\_enable\_network\_threshold) | Enable network threshold or no | `bool` | `true` | no |
| <a name="input_enable_restart_threshold"></a> [enable\_restart\_threshold](#input\_enable\_restart\_threshold) | Enable restart threshold or no | `bool` | `true` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment Name | `string` | `""` | no |
| <a name="input_error_filter_pattern"></a> [error\_filter\_pattern](#input\_error\_filter\_pattern) | Log group error filter pattern | `string` | `"Error"` | no |
| <a name="input_error_period"></a> [error\_period](#input\_error\_period) | Error Period | `string` | `"3600"` | no |
| <a name="input_error_statistic"></a> [error\_statistic](#input\_error\_statistic) | Error Statistic | `string` | `"Sum"` | no |
| <a name="input_error_threshold"></a> [error\_threshold](#input\_error\_threshold) | Error threshold | `string` | `"10"` | no |
| <a name="input_error_unit"></a> [error\_unit](#input\_error\_unit) | Error Unit | `string` | `"Percent"` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | Metric filter create in log group. | `string` | `""` | no |
| <a name="input_memory_period"></a> [memory\_period](#input\_memory\_period) | Memory Period | `string` | `"300"` | no |
| <a name="input_memory_statistic"></a> [memory\_statistic](#input\_memory\_statistic) | Memory Statistic | `string` | `"Average"` | no |
| <a name="input_memory_threshold"></a> [memory\_threshold](#input\_memory\_threshold) | Memory Trashold | `string` | `"50"` | no |
| <a name="input_memory_unit"></a> [memory\_unit](#input\_memory\_unit) | Memory Unit | `string` | `"Percent"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Pod Namespace | `string` | n/a | yes |
| <a name="input_network_period"></a> [network\_period](#input\_network\_period) | Network Period | `string` | `"300"` | no |
| <a name="input_network_statistic"></a> [network\_statistic](#input\_network\_statistic) | Network Statistic | `string` | `"Average"` | no |
| <a name="input_network_threshold"></a> [network\_threshold](#input\_network\_threshold) | Networ Threshold | `string` | `"5000"` | no |
| <a name="input_network_unit"></a> [network\_unit](#input\_network\_unit) | Network Unit | `string` | `"Bytes/Second"` | no |
| <a name="input_opsgenie_endpoints"></a> [opsgenie\_endpoints](#input\_opsgenie\_endpoints) | Opsigenie platform integration url | `list(string)` | `[]` | no |
| <a name="input_pod_name"></a> [pod\_name](#input\_pod\_name) | Pod Name | `string` | n/a | yes |
| <a name="input_restart_period"></a> [restart\_period](#input\_restart\_period) | Restart Period | `string` | `"60"` | no |
| <a name="input_restart_statistic"></a> [restart\_statistic](#input\_restart\_statistic) | Restart Statistic | `string` | `"Maximum"` | no |
| <a name="input_restart_threshold"></a> [restart\_threshold](#input\_restart\_threshold) | Restart Count | `string` | `"1"` | no |
| <a name="input_restart_unit"></a> [restart\_unit](#input\_restart\_unit) | Restart Unit | `string` | `"Count"` | no |
| <a name="input_slack_channel"></a> [slack\_channel](#input\_slack\_channel) | Slack Channel | `string` | `""` | no |
| <a name="input_slack_hook_url"></a> [slack\_hook\_url](#input\_slack\_hook\_url) | This is slack webhook url path without domain | `string` | `""` | no |
| <a name="input_slack_username"></a> [slack\_username](#input\_slack\_username) | Slack User Name | `string` | `""` | no |
| <a name="input_sms_message_body"></a> [sms\_message\_body](#input\_sms\_message\_body) | n/a | `string` | `"sms_message_body"` | no |
| <a name="input_sns_subscription_email_address_list"></a> [sns\_subscription\_email\_address\_list](#input\_sns\_subscription\_email\_address\_list) | List of email addresses | `list(string)` | `[]` | no |
| <a name="input_sns_subscription_phone_number_list"></a> [sns\_subscription\_phone\_number\_list](#input\_sns\_subscription\_phone\_number\_list) | List of telephone numbers to subscribe to SNS. | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
