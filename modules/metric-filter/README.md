```
module "cloudwatch_metric_filter" {
  source = "dasmeta/modules/aws//modules/metric-filter"

  // Dimensions only applicable for JSON or delimited filter patterns
  metrics_patterns = [
    {
      name    = "ERROR"
      pattern = "ERROR"
      unit    = "None"
      dimensions = {}
    }
  ]
  log_group_name    = "/aws/containerinsights/dasmeta-test-new2/prometheus"
  metrics_namespace = "Log_Filters"
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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_metric_filter.metric_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_metrics_namespace"></a> [metrics\_namespace](#input\_metrics\_namespace) | n/a | `string` | `"Log_Filters"` | no |
| <a name="input_metrics_patterns"></a> [metrics\_patterns](#input\_metrics\_patterns) | n/a | `any` | <pre>[<br>  {<br>    "dimensions": {},<br>    "name": "ERROR",<br>    "pattern": "ERROR",<br>    "unit": "None"<br>  }<br>]</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
