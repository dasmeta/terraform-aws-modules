## Example

1. Apply module

```
module "dashboard" {
  source = "dasmeta/modules/aws//modules/dashborad"

  yaml_file_path = "./dashboards.yaml"
}

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.30.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_compose"></a> [compose](#module\_compose) | ./compose | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_dashboard.error_metric_include2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_yaml_file_path"></a> [yaml\_file\_path](#input\_yaml\_file\_path) | n/a | `string` | `"./dashboards.yaml"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->