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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                       | Type     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_cloudwatch_log_metric_filter.metric_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |

## Inputs

| Name                                                                                 | Description | Type     | Default                                                                                               | Required |
| ------------------------------------------------------------------------------------ | ----------- | -------- | ----------------------------------------------------------------------------------------------------- | :------: |
| <a name="input_log_group_name"></a> [log_group_name](#input_log_group_name)          | n/a         | `string` | n/a                                                                                                   |   yes    |
| <a name="input_metrics_namespace"></a> [metrics_namespace](#input_metrics_namespace) | n/a         | `string` | `"Log_Filters"`                                                                                       |    no    |
| <a name="input_metrics_patterns"></a> [metrics_patterns](#input_metrics_patterns)    | n/a         | `any`    | <pre>[<br> {<br> "dimensions": {},<br> "name": "",<br> "pattern": "",<br> "unit": ""<br> }<br>]</pre> |    no    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
