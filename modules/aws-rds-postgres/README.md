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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

No requirements.

## Providers

| Name                                                      | Version |
| --------------------------------------------------------- | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws)          | n/a     |
| <a name="provider_random"></a> [random](#provider_random) | n/a     |

## Modules

| Name                                      | Source                        | Version |
| ----------------------------------------- | ----------------------------- | ------- |
| <a name="module_db"></a> [db](#module_db) | terraform-aws-modules/rds/aws | ~> 2.0  |

## Resources

| Name                                                                                                                | Type        |
| ------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource    |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource    |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc)                   | data source |

## Inputs

| Name                                                                                                   | Description                                                                                                                                             | Type           | Default                  | Required |
| ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ------------------------ | :------: |
| <a name="input_backup_retention_period"></a> [backup_retention_period](#input_backup_retention_period) | Number of days backups will be kept                                                                                                                     | `number`       | `7`                      |    no    |
| <a name="input_create_db_subnet_group"></a> [create_db_subnet_group](#input_create_db_subnet_group)    | n/a                                                                                                                                                     | `bool`         | `true`                   |    no    |
| <a name="input_create_security_group"></a> [create_security_group](#input_create_security_group)       | Create Security group                                                                                                                                   | `bool`         | `true`                   |    no    |
| <a name="input_database"></a> [database](#input_database)                                              | n/a                                                                                                                                                     | `string`       | n/a                      |   yes    |
| <a name="input_db_subnet_group_name"></a> [db_subnet_group_name](#input_db_subnet_group_name)          | Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC | `string`       | `null`                   |    no    |
| <a name="input_engine_version"></a> [engine_version](#input_engine_version)                            | Postgres engine version                                                                                                                                 | `string`       | `"11.12"`                |    no    |
| <a name="input_instance_class"></a> [instance_class](#input_instance_class)                            | Underlaying ec2 instance class                                                                                                                          | `string`       | `"db.t2.micro"`          |    no    |
| <a name="input_ip_ranges"></a> [ip_ranges](#input_ip_ranges)                                           | n/a                                                                                                                                                     | `list(string)` | `[]`                     |    no    |
| <a name="input_monitoring_role_name"></a> [monitoring_role_name](#input_monitoring_role_name)          | IAM Role name                                                                                                                                           | `string`       | `"MyRDSMonitoringRole"`  |    no    |
| <a name="input_name"></a> [name](#input_name)                                                          | n/a                                                                                                                                                     | `string`       | n/a                      |   yes    |
| <a name="input_password"></a> [password](#input_password)                                              | n/a                                                                                                                                                     | `string`       | `""`                     |    no    |
| <a name="input_publicly_accessible"></a> [publicly_accessible](#input_publicly_accessible)             | Bool to control if instance is publicly accessible                                                                                                      | `bool`         | `false`                  |    no    |
| <a name="input_security_group_ids"></a> [security_group_ids](#input_security_group_ids)                | Security group name                                                                                                                                     | `list(string)` | <pre>[<br> ""<br>]</pre> |    no    |
| <a name="input_storage"></a> [storage](#input_storage)                                                 | Storage voluem size - cannot be decreased after creation                                                                                                | `number`       | `20`                     |    no    |
| <a name="input_subnet_ids"></a> [subnet_ids](#input_subnet_ids)                                        | n/a                                                                                                                                                     | `list(string)` | n/a                      |   yes    |
| <a name="input_username"></a> [username](#input_username)                                              | n/a                                                                                                                                                     | `string`       | n/a                      |   yes    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                                    | n/a                                                                                                                                                     | `string`       | n/a                      |   yes    |

## Outputs

| Name                                                        | Description |
| ----------------------------------------------------------- | ----------- |
| <a name="output_endpoint"></a> [endpoint](#output_endpoint) | n/a         |
| <a name="output_password"></a> [password](#output_password) | n/a         |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
