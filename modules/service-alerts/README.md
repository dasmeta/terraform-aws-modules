# Module Use Case

module "cloudwatchalarm" {
    source  = "../../terraform-aws-modules/modules/service-alerts"

    cluster_name = "eks-cluster-name"
    service_name = "eks-service-name"
    namespace    = "eks-service-namespace"

    cpu_threshold = "50"
    memory_threshold = "50"
    network_threshold = "1000"

    error_threshold = "10"
    log_group_name  = "/aws/example/"

    create_dashboard = true

    sns_subscription_email_address_list = ["julia@dasmeta.com"]
}