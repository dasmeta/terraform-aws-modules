## Example
```
module "postgres" {
  source     = "../../../../dasmeta/terraform/modules/aws-rds-postgres"
  name       = "instance"
  database   = "database"
  username   = "username"

  vpc_id     = var.vpc_id # vpc-745836783
  subnet_ids = var.vpc_subnet_ids # ["subnet-457845", "subnet-54875787"]
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds/aws | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | Number of days backups will be kept | `number` | `7` | no |
| <a name="input_create_db_subnet_group"></a> [create\_db\_subnet\_group](#input\_create\_db\_subnet\_group) | n/a | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Create Security group | `bool` | `true` | no |
| <a name="input_database"></a> [database](#input\_database) | n/a | `string` | n/a | yes |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC | `string` | `null` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Postgres engine version | `string` | `"11.12"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | Underlaying ec2 instance class | `string` | `"db.t2.micro"` | no |
| <a name="input_ip_ranges"></a> [ip\_ranges](#input\_ip\_ranges) | n/a | `list(string)` | `[]` | no |
| <a name="input_monitoring_role_name"></a> [monitoring\_role\_name](#input\_monitoring\_role\_name) | IAM Role name | `string` | `"MyRDSMonitoringRole"` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | n/a | `string` | `""` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Bool to control if instance is publicly accessible | `bool` | `false` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security group name | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_storage"></a> [storage](#input\_storage) | Storage voluem size - cannot be decreased after creation | `number` | `20` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | n/a | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | n/a |
| <a name="output_password"></a> [password](#output\_password) | n/a |
<!-- END_TF_DOCS -->
