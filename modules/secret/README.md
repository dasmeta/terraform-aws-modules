```
# How to use

## Example usage 1 (when the secret is a value)
module test-secret {
  source  = "dasmeta/modules/aws//modules/cloudwatch"

  name = "test-secret"
  value = "test-secret-value"
}


## Example usage 2 (when the secret is a key-value pair)
module test-secret {
  source  = "dasmeta/modules/aws//modules/cloudwatch"

  name = "test-secret"
  value = {
    "key1": "value1"
    "key2": "value2"
    "key3": "value3"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.43 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.43 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.value](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret. | `any` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Secret name | `string` | n/a | yes |
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | (Optional) Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. The default value is 30 | `number` | `30` | no |
| <a name="input_value"></a> [value](#input\_value) | Secret value | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | The ID of created secret |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
