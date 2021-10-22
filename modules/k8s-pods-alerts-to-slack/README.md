```hcl

module route53-health-check-to-slack {
    source           = "dasmeta/modules/aws//modules/k8s-pods-alerts-to-slack"
    pod_name       = "pod-name"
    dimensions                = {
        "ClusterName" = "cluster-name"
        "Namespace"   = "default"
        "PodName"     = "pod-name"
    }
    slack_hook_url   = "/services/T86984594/B02J5AK41A8/ksjdhfksdjhKJHGJKHGJK"
}

```