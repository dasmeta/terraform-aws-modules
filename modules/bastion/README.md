# Setup
- make sure default vpc has internet gateway attached to
- make sure route tables have 0.0.0.0/0 pointing to internet gateway

## ToDo
- consider using Amazon Linux 2 AMI
- consider using nano instance
- consider adding dns record to access instance via domain name


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 0.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ami"></a> [ami](#module\_ami) | ../ami | n/a |
| <a name="module_ec2_instance"></a> [ec2\_instance](#module\_ec2\_instance) | terraform-aws-modules/ec2-instance/aws | ~> 3.0 |
| <a name="module_security-group-ssh"></a> [security-group-ssh](#module\_security-group-ssh) | terraform-aws-modules/security-group/aws//modules/ssh | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_subnets.all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpcs.all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpcs) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
