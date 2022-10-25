## Module can read secret manager data with name

### Example 1. Get all data
```
module "secret_manager" {
  source = "../terraform/"
  name   = "lambda_envs"
}

locals {
  PATH = module.secret_manager.secrets["PATH"]
}

resource "null_resource" "secret_manager" {
  provisioner "local-exec" {
    command = "echo ${local.PATH}"
  }
}
```

### Example 2. Get data with key

```
module "secret_manager" {
  source = "../terraform/"
  name   = "lambda_envs"
  secret_key = "PATH"
}

resource "null_resource" "secret_manager" {
  provisioner "local-exec" {
    command = "echo ${module.secret_manager.secret_value}"
  }
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
| [aws_secretsmanager_secret.by_secret_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Your secret name | `string` | n/a | yes |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | You can get secret value if set key name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_value"></a> [secret\_value](#output\_secret\_value) | n/a |
| <a name="output_secrets"></a> [secrets](#output\_secrets) | n/a |
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| [aws_secretsmanager_secret.by_secret_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Your secret name | `string` | n/a | yes |
| <a name="input_secret_key"></a> [secret\_key](#input\_secret\_key) | You can get secret value if set key name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_value"></a> [secret\_value](#output\_secret\_value) | n/a |
| <a name="output_secrets"></a> [secrets](#output\_secrets) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
