```
module "cloudwatch_metric_filter" {
  source = "../"

  log_groups = {
    group1 = "/aws/containerinsights/dasmeta-test-new3/performance"
    group2 = "/aws/eks/dasmeta-test-new3/cluster"
  }

  patterns = [
    {
      // Dimensions only applicable for JSON or delimited filter patterns
      name    = "errors"
      source  = "group1"
      pattern = "{ $.ClusterName = \"*dasmeta-test-new3*\" }"
      dimensions = {
        "ClusterName" = "$.ClusterName"
      }
    },
    {
      name       = "errors2"
      source     = "group2"
      pattern    = "info"
      dimensions = {}
    }
  ]

  metrics_namespace = "Log_Filters"
}
```

This results in:
Log_Filters/GroupKey/Name

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.16 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudwatch_metric_filter"></a> [cloudwatch\_metric\_filter](#module\_cloudwatch\_metric\_filter) | ../metric-filter | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_log_groups"></a> [log\_groups](#input\_log\_groups) | n/a | `map(any)` | `{}` | no |
| <a name="input_metrics_namespace"></a> [metrics\_namespace](#input\_metrics\_namespace) | n/a | `string` | `"LogBasedMetrics"` | no |
| <a name="input_patterns"></a> [patterns](#input\_patterns) | n/a | `list(any)` | `[]` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
