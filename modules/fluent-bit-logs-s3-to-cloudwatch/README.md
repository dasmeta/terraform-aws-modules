# Create S3 bucket for FluentBit and enable lambda for move data to CloudWatch

```
module "s3-to-cloudwatch" {
  source                         = "dasmeta/modules/aws//modules/fluent-bit-logs-s3-to-cloudwatch"
  bucket_name                    = "test-fluent-bit-bla2"
  assume_role_arn                = ["arn:aws:iam::5*68:role/eks-cluster-fluent-bit"]
}
```

# Create S3 bucket for FluentBit and disable lambda 

```
module "s3-to-cloudwatch" {
  source                         = "dasmeta/modules/aws//modules/fluent-bit-logs-s3-to-cloudwatch"
  bucket_name                    = "test-fluent-bit-bla2"
  create_lambda_s3_to_cloudwatch = false
  assume_role_arn                = ["arn:aws:iam::5*68:role/eks-cluster-fluent-bit"]
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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_logs_to_cloudwatch"></a> [s3\_logs\_to\_cloudwatch](#module\_s3\_logs\_to\_cloudwatch) | ./terraform-aws-alb-cloudwatch-logs-json | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_permission.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_ownership_controls.disable_s3_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.allow_access_from_another_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_iam_policy_document.allow_access_from_another_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | AWS Acounts Assume roles arn which access bucket write | `list(string)` | <pre>[<br>  "arn:aws:iam::*:role/eks-cluster-fluent-bit-role"<br>]</pre> | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | `"test-fluent-bit-bla"` | no |
| <a name="input_create_lambda_s3_to_cloudwatch"></a> [create\_lambda\_s3\_to\_cloudwatch](#input\_create\_lambda\_s3\_to\_cloudwatch) | n/a | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->