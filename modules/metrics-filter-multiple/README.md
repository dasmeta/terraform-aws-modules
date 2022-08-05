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


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

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
| <a name="input_log_groups"></a> [log\_groups](#input\_log\_groups) | n/a | `map(any)` | <pre>{<br>  "group1": "/group/one/path",<br>  "group2": "/group/two/path",<br>  "groupN": "/group/nnn/path"<br>}</pre> | no |
| <a name="input_metrics_namespace"></a> [metrics\_namespace](#input\_metrics\_namespace) | n/a | `string` | `"LogBasedMetrics"` | no |
| <a name="input_patterns"></a> [patterns](#input\_patterns) | n/a | `list(any)` | <pre>[<br>  {<br>    "dimensions": {},<br>    "name": "errors",<br>    "pattern": "error",<br>    "source": "group1"<br>  }<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
