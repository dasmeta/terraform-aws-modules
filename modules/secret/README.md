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

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                 | Type     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_secretsmanager_secret.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret)                | resource |
| [aws_secretsmanager_secret_version.value](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name                                             | Description  | Type     | Default | Required |
| ------------------------------------------------ | ------------ | -------- | ------- | :------: |
| <a name="input_name"></a> [name](#input_name)    | Secret name  | `string` | n/a     |   yes    |
| <a name="input_value"></a> [value](#input_value) | Secret value | `any`    | `null`  |    no    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
