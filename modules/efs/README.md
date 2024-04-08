### Module to provision `AWS EFS Filesystem`

### How to Optimize EFS Cost
[AWS Docs](https://docs.aws.amazon.com/efs/latest/ug/availability-durability.html#storage-classes) tells:
Amazon EFS offers different storage classes that are designed for the most effective storage depending on use cases.
- EFS Standard
- EFS Infrequent Access (IA)
- EFS Archive

The IA and Archive storage classes are cost-optimized for files that don’t require the latency performance of the Standard storage. First byte latency when reading from either of the infrequently accessed storage classes is higher than that for the Standard storage class.

Using lifecycle management, you can optimize storage costs by automatically tiering data between storage classes based on your workload's access patterns.

This module supports lifecycle management which is enabled by default. Check `/tests/lifecycle-policy-changed` and see how the default values can be modified.

#### Minimal usage
```
module "efs" {
  source = "dasmeta/modules/aws//modules/efs"
  creation_token = "EFS"
}
```

#### Integrated with a VPC
This example enables EFS access to a VPC. For example, it can be the VPC of EKS cluster.
```
module "efs" {
  source = "dasmeta/modules/aws//modules/efs"
  creation_token = "EFS"
  mount_target_subnets = ["sub-xxx", "sub-yyy", "sub-zzz"]
  eks_vpc_id = "vpc-1212121212121"
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

#### Regular usage, multiple mount points
```
module "efs" {
  source = "dasmeta/modules/aws//modules/efs"
  encrypted = true
  kms_key_id = aws_kms_key.key.arn
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"
  mount_target_subnets = ["sub-xxx", "sub-yyy", "sub-zzz"]
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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.mount_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_security_group.efs_kube_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone_prefix"></a> [availability\_zone\_prefix](#input\_availability\_zone\_prefix) | Availability zone prefix, concat later to region code | `string` | `""` | no |
| <a name="input_creation_token"></a> [creation\_token](#input\_creation\_token) | Creation token, same as unique name | `string` | `"EFS-creation-token"` | no |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | Weather make encrypted or not | `bool` | `false` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | AWS kms key arn | `string` | `null` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | A block representing the lifecycle policy for the file system. | `any` | <pre>{<br>  "transition_to_archive": "AFTER_60_DAYS",<br>  "transition_to_ia": "AFTER_30_DAYS",<br>  "transition_to_primary_storage_class": null<br>}</pre> | no |
| <a name="input_mount_target_subnets"></a> [mount\_target\_subnets](#input\_mount\_target\_subnets) | Subnet in which to create mount target | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | EFS name | `string` | `"EFS"` | no |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | Performance mode for EFS | `string` | `null` | no |
| <a name="input_provisioned_throughput_in_mibps"></a> [provisioned\_throughput\_in\_mibps](#input\_provisioned\_throughput\_in\_mibps) | Throughput mibps for EFS, Only compliant when throughput mode is set to provisioned | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br>  "Provisioner": "DasMeta"<br>}</pre> | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | Throughput mode for the file system. Valid values: bursting, provisioned, or elastic. When using 'provisioned', also set 'provisioned\_throughput\_in\_mibps'. | `string` | `"elastic"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to which EFS will have access | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_az"></a> [az](#output\_az) | n/a |
| <a name="output_efs_creation_token"></a> [efs\_creation\_token](#output\_efs\_creation\_token) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
