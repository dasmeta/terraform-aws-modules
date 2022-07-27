# This module create metric filter on CloudWatch log group.

Note.

 Metrics that have not had any new data points in the past two weeks do not appear in the console. They also do not appear when you type their metric name or dimension names in the ///search box in the All metrics tab in the console, and they are not returned in the results of a list-metrics command. The best way to retrieve these metrics is with the get-metric-data or get-metric-statistics commands in the AWS CLI. -->


## Example 1. Create Log group and metric filter.
```
module "aws_cloudwatch_log_metric_filter" {
    source = "dasmeta/modules/aws//modules/cloudwatch-log-metric"

    name             = "example"
    filter_pattern   = "ERROR"
    create_log_group = true
    log_group_name   = "/aws/example/"
    metric_name      = "metric-name"
}
```

## Example 2. Add metric filter existing in the log group
```
module "aws_cloudwatch_log_metric_filter" {
    source = "dasmeta/modules/aws//modules/cloudwatch-log-metric"

    name             = "example"
    filter_pattern   = "ERROR"
    create_log_group = false
    log_group_name   = "/aws/cognito/userpools/"
    metric_name      = "metric-name"
}
```
## Example 3. Create Log group and metric filter override default values.
```
module "aws_cloudwatch_log_metric_filter" {
    source = "dasmeta/modules/aws//modules/cloudwatch-log-metric"

    name             = "example"
    filter_pattern   = "ERROR"
    create_log_group = true
    log_group_name   = "/aws/example/"
    metric_name      = "metric-name"
    metric_namespace = "metric-namespace"
    metric_value     = "1"
    metric_unit      = "None"
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
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_metric_filter.metric_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_log_group"></a> [create\_log\_group](#input\_create\_log\_group) | The name of the log group to associate the metric filter with. | `bool` | `false` | no |
| <a name="input_filter_pattern"></a> [filter\_pattern](#input\_filter\_pattern) | A valid CloudWatch Logs filter pattern for extracting metric data out of ingested log events. | `string` | n/a | yes |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | The name of the log group to associate the metric filter with. | `string` | `false` | no |
| <a name="input_metric_name"></a> [metric\_name](#input\_metric\_name) | The name of the CloudWatch metric to which the monitored log information should be published . | `string` | n/a | yes |
| <a name="input_metric_namespace"></a> [metric\_namespace](#input\_metric\_namespace) | The destination namespace of the CloudWatch metric | `string` | `"LogGroupFilter"` | no |
| <a name="input_metric_unit"></a> [metric\_unit](#input\_metric\_unit) | (Optional) The unit to assign to the metric. If you omit this, the unit is set as None | `string` | `"None"` | no |
| <a name="input_metric_value"></a> [metric\_value](#input\_metric\_value) | What to publish to the metric. For example, if you're counting the occurrences of a particular term like 'Error', the value will be '1' for each occurrence. If you're counting the bytes transferred the published value will be the value in the log event. | `string` | `"1"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the metric filter | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_metric_filter_id"></a> [metric\_filter\_id](#output\_metric\_filter\_id) | n/a |
<!-- END_TF_DOCS -->
