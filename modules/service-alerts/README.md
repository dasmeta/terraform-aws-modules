# Module Use Case
```
module "cloudwatchalarm" {
    source  = "../../terraform-aws-modules/modules/service-alerts"

    cluster_name = "eks-cluster-name"
    pod_name     = "eks-service-name"
    namespace    = "eks-service-namespace"

    cpu_threshold     = "50"
    memory_threshold  = "50"
    network_threshold = "1000"
    restart_count     = "5"  

    error_filter      =  false 

    # You can add error filter in log group 
    error_filter    = true
    error_threshold = "10"
    log_group_name  = "/aws/example/"

    create_dashboard = true

    sns_subscription_email_address_list = ["devops@domain.com"]
}
```
