### Module to provision `AWS EFS Filesystem`

#### Minimal usage
```
module "efs" {
  source = "dasmeta/modules/aws//modules/efs"
  creation_token = "EFS"
}
```

#### Regular usage
```
module "efs" {
  source = "dasmeta/modules/aws//modules/efs"
  creation_token = "EFS"
  availability_zone_prefix = "a"
  encrypted = true
  kms_key_id = aws_kms_key.key.arn
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
}

resource "aws_kms_key" "key" {
  description             = "kms-key"
  deletion_window_in_days = 10
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone_prefix"></a> [availability\_zone\_prefix](#input\_availability\_zone\_prefix) | Availability zone prefix, concat later to region code | `string` | `"a"` | no |
| <a name="input_creation_token"></a> [creation\_token](#input\_creation\_token) | Creation token, same as unique name | `string` | n/a | yes |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | Weather make encrypted or not | `bool` | `false` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | AWS kms key arn | `string` | `null` | no |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | Performance mode for EFS | `string` | `null` | no |
| <a name="input_provisioned_throughput_in_mibps"></a> [provisioned\_throughput\_in\_mibps](#input\_provisioned\_throughput\_in\_mibps) | Throughput mibps for EFS, Only compliant when throughput mode is set to provisioned | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "Provisioner": "DasMeta"<br>}</pre> | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | Throughput mode for EFS, when set to provisioned also need to set `provisioned_throughput_in_mibps` | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_az"></a> [az](#output\_az) | n/a |
| <a name="output_efs_creation_token"></a> [efs\_creation\_token](#output\_efs\_creation\_token) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
