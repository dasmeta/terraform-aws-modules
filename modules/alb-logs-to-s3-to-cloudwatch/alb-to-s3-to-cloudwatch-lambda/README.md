# terraform-aws-alb-cloudwatch-logs-json

This Terraform module ships AWS ALB logs to CloudWatch Logs in JSON format.

## Requirements

* Terraform 0.12.x
* Python

## Example

```tf
resource "aws_cloudwatch_log_group" "test" {
  name              = aws_alb.test.name
  retention_in_days = 365
}

module "alb_logs_to_cloudwatch" {
  source  = "terraform-aws-alb-cloudwatch-logs-json"
  version = "1.0.0"

  bucket_name    = aws_s3_bucket.logs.bucket
  log_group_name = aws_cloudwatch_log_group.test.name

  create_alarm  = true
  alarm_actions = [aws_sns_topic.slack.arn]
  ok_actions    = [aws_sns_topic.slack.arn]
}

resource "aws_lambda_permission" "bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.alb_logs_to_cloudwatch.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.logs.arn
}

resource "aws_s3_bucket_notification" "logs" {
  bucket     = aws_s3_bucket.logs.bucket
  depends_on = ["aws_lambda_permission.bucket"]

  lambda_function {
    lambda_function_arn = module.alb_logs_to_cloudwatch.function_arn
    events              = ["s3:ObjectCreated:*"]
  }
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | 4.7.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.errors](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | n/a | yes |
| <a name="input_create_alarm"></a> [create\_alarm](#input\_create\_alarm) | n/a | `bool` | `false` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | n/a | `string` | `""` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Memory size for Lambda function | `number` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Timeout for Lambda function | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | n/a |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
