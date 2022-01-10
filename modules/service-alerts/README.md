# Module Use Case 

## Case 1
```
module "cloudwatchalarm" {
    source  = "../../terraform-aws-modules/modules/service-alerts"

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
    source  = "../../terraform-aws-modules/modules/service-alerts"

    cluster_name = "eks-cluster-name"
    pod_name     = "eks-pod-name"
    namespace    = "eks-pod-namespace"

    cpu_threshold = "50"
    memory_threshold = "50"
    network_threshold = "1000"
    restart_count   = "10"

    error_threshold = "10"
    log_group_name  = "/aws/example/"

//  You can disable alarms, default all is true
    enable_error_filter  = false
    enable_cpu_threshold = false
    enable_memory_threshold  = false
    enable_network_threshold = false
    enable_restart_count     = false

    create_dashboard = true

    sns_subscription_email_address_list = ["devops@domain.com"]
}
```

## Case 3
```
module "cloudwatchalarm" {
    source  = "../../terraform-aws-modules/modules/service-alerts"

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

    restart_count   = "1"
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
    enable_restart_count     = false

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
