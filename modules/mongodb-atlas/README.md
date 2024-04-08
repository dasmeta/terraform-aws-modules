# How to
1. create a Mongo Atlas organization at https://www.mongodb.com/cloud/atlas
2. setup api key at org settings section > API Keys
3. run
```
module "mongodb-atlas" {
  source = "dasmeta/modules/aws//modules/mongodb-atlas"

  org_id = "some mongo atlas or id"
  public_key = "mongo atlas public key"
  private_key = "mongo atlas private key"

  project_name = "your project name goes here"

  users = [
        {
          username = "user1"
          roles = {
            database_name = "admin"
            role_name     = "readWriteAnyDatabase"
          }
          scopes = {
            name = "test-development"
            type = "CLUSTER"
          }
        },
        {
          username = "user2"
          roles = {
            database_name = "database"
            role_name     = "readWrite"
          }
          scopes = {
            name = "cluster"
            type = "CLUSTER"
          }
        }
      ]
  ip_addresses = ["ip1", "ip2", "ip3", "ipN"]

  access_users = [
      {
            username     = "test1@dasmeta.com"
            roles         = ["ORG_OWNER" , "ORG_BILLING_ADMIN" ]
            project_roles = ["GROUP_DATA_ACCESS_READ_WRITE"]
      },
      {
            username     = "test@gmail.com"
            roles         = ["ORG_OWNER" , "ORG_BILLING_ADMIN" ]
            project_roles = ["GROUP_DATA_ACCESS_READ_WRITE"]
      }
  ]
}
```

## Issues
mongodbatlas_cloud_provider_snapshot_backup_policy resource requires access through an access list of IP ranges. To solve this problem you need to
1. open Organization -> Settings and set Require IP Access List for Public API ON,
2. add the source IP in the API key access list:
   Organization -> Access Manager -> API Keys -> Edit API key permissions -> Next -> ADD ACCESS LIST ENTRY -> Add your source IP
   (to do so you can also add your current IP address as a source one).

## Tips
1. You need to pass "" to `retention_unit` to turn some `policy_items` off in `mongodbatlas_cloud_backup_schedule`. For example, if var.policy_item_hourly.retention_unit = "" then `policy_item_hourly` is not created.
2. `mongodbatlas_cloud_provider_snapshot_backup_policy` resource is deprecated but if there is a need to use it, make `use_cloud_provider_snapshot_backup_policy` true.
3. There is a problem in MongoDB provider with invitations for users. You can make them by this module, but it'll be better to delete `mongodbatlas_org_invitation` and `mongodbatlas_project_invitation` resources from the state.
4. You need to pass the role and scope blocks for each user to create them. Just pass a list of objects to the `users` variable.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.72 |
| <a name="requirement_mongodbatlas"></a> [mongodbatlas](#requirement\_mongodbatlas) | ~> 1.15.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.72 |
| <a name="provider_mongodbatlas"></a> [mongodbatlas](#provider\_mongodbatlas) | ~> 1.15.2 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route.mongo_route_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection_accepter.aws_peers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [mongodbatlas_alert_configuration.main](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/alert_configuration) | resource |
| [mongodbatlas_auditing.audit](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/auditing) | resource |
| [mongodbatlas_cloud_backup_schedule.backup](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/cloud_backup_schedule) | resource |
| [mongodbatlas_cluster.main](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/cluster) | resource |
| [mongodbatlas_database_user.user](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/database_user) | resource |
| [mongodbatlas_network_peering.mongo_peers](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/network_peering) | resource |
| [mongodbatlas_org_invitation.org_invitation](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/org_invitation) | resource |
| [mongodbatlas_project.main](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project) | resource |
| [mongodbatlas_project_invitation.project_invitation](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project_invitation) | resource |
| [mongodbatlas_project_ip_access_list.ip-access-list](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project_ip_access_list) | resource |
| [mongodbatlas_project_ip_access_list.vpc_cidr_whitelist](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project_ip_access_list) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_route_table.peering_vpcs_route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_vpc.peering_vpcs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_users"></a> [access\_users](#input\_access\_users) | Access Users | <pre>list(object({<br>    username      = string,<br>    roles         = list(string),<br>    project_roles = set(string)<br>  }))</pre> | `[]` | no |
| <a name="input_alert_delay_min"></a> [alert\_delay\_min](#input\_alert\_delay\_min) | Number of minutes to wait after an alert condition is detected before sending out the first notification. | `number` | `0` | no |
| <a name="input_alert_email_enabled"></a> [alert\_email\_enabled](#input\_alert\_email\_enabled) | Flag indicating if email notifications should be sent. | `bool` | `true` | no |
| <a name="input_alert_event_type"></a> [alert\_event\_type](#input\_alert\_event\_type) | The type of event that will trigger an alert. | `string` | `"OUTSIDE_METRIC_THRESHOLD"` | no |
| <a name="input_alert_interval_min"></a> [alert\_interval\_min](#input\_alert\_interval\_min) | Number of minutes to wait between successive notifications for unacknowledged alerts that are not resolved. | `number` | `5` | no |
| <a name="input_alert_metric_name"></a> [alert\_metric\_name](#input\_alert\_metric\_name) | Name of the metric to check. | `string` | `"NORMALIZED_SYSTEM_CPU_USER"` | no |
| <a name="input_alert_mode"></a> [alert\_mode](#input\_alert\_mode) | This must be set to AVERAGE. Atlas computes the current metric value as an average. | `string` | `"AVERAGE"` | no |
| <a name="input_alert_operator"></a> [alert\_operator](#input\_alert\_operator) | Operator to apply when checking the current metric value against the threshold value. | `string` | `"GREATER_THAN"` | no |
| <a name="input_alert_roles"></a> [alert\_roles](#input\_alert\_roles) | The following roles grant privileges within a project. | `list(string)` | <pre>[<br>  "GROUP_CLUSTER_MANAGER",<br>  "GROUP_OWNER"<br>]</pre> | no |
| <a name="input_alert_sms_enabled"></a> [alert\_sms\_enabled](#input\_alert\_sms\_enabled) | Flag indicating if text message notifications should be sent. | `bool` | `false` | no |
| <a name="input_alert_threshold"></a> [alert\_threshold](#input\_alert\_threshold) | Threshold value outside of which an alert will be triggered. | `number` | `99` | no |
| <a name="input_alert_type_name"></a> [alert\_type\_name](#input\_alert\_type\_name) | The type of alert notification. | `string` | `"GROUP"` | no |
| <a name="input_alert_units"></a> [alert\_units](#input\_alert\_units) | The units for the threshold value. Depends on the type of metric. | `string` | `"RAW"` | no |
| <a name="input_audit_filter"></a> [audit\_filter](#input\_audit\_filter) | JSON-formatted audit filter. All filters are chosen by default. | `map` | <pre>{<br>  "$or": [<br>    {<br>      "users": []<br>    },<br>    {<br>      "$and": [<br>        {<br>          "$or": [<br>            {<br>              "users": {<br>                "$elemMatch": {<br>                  "$or": [<br>                    {<br>                      "db": "admin"<br>                    },<br>                    {<br>                      "db": "$external"<br>                    }<br>                  ]<br>                }<br>              }<br>            },<br>            {<br>              "roles": {<br>                "$elemMatch": {<br>                  "$or": [<br>                    {<br>                      "db": "admin"<br>                    }<br>                  ]<br>                }<br>              }<br>            }<br>          ]<br>        },<br>        {<br>          "$or": [<br>            {<br>              "atype": "authCheck",<br>              "param.command": {<br>                "$in": [<br>                  "aggregate",<br>                  "count",<br>                  "distinct",<br>                  "group",<br>                  "mapReduce",<br>                  "geoNear",<br>                  "geoSearch",<br>                  "eval",<br>                  "find",<br>                  "getLastError",<br>                  "getMore",<br>                  "getPrevError",<br>                  "parallelCollectionScan",<br>                  "delete",<br>                  "findAndModify",<br>                  "insert",<br>                  "update",<br>                  "resetError"<br>                ]<br>              }<br>            },<br>            {<br>              "atype": {<br>                "$in": [<br>                  "authenticate",<br>                  "createCollection",<br>                  "createDatabase",<br>                  "createIndex",<br>                  "renameCollection",<br>                  "dropCollection",<br>                  "dropDatabase",<br>                  "dropIndex",<br>                  "createUser",<br>                  "dropUser",<br>                  "dropAllUsersFromDatabase",<br>                  "updateUser",<br>                  "grantRolesToUser",<br>                  "revokeRolesFromUser",<br>                  "createRole",<br>                  "updateRole",<br>                  "dropRole",<br>                  "dropAllRolesFromDatabase",<br>                  "grantRolesToRole",<br>                  "revokeRolesFromRole",<br>                  "grantPrivilegesToRole",<br>                  "revokePrivilegesFromRole",<br>                  "enableSharding",<br>                  "shardCollection",<br>                  "addShard",<br>                  "removeShard",<br>                  "shutdown",<br>                  "applicationMessage"<br>                ]<br>              }<br>            }<br>          ]<br>        }<br>      ]<br>    }<br>  ]<br>}</pre> | no |
| <a name="input_backing_provider_name"></a> [backing\_provider\_name](#input\_backing\_provider\_name) | Cloud service provider on which the server for a multi-tenant cluster is provisioned, valid for only when instanceSizeName is M2 or M5. | `string` | `null` | no |
| <a name="input_cloud_backup"></a> [cloud\_backup](#input\_cloud\_backup) | Enable Cloud Backup. | `bool` | `true` | no |
| <a name="input_cluster_configs"></a> [cluster\_configs](#input\_cluster\_configs) | Mongo atlas cluster configurations | <pre>object({<br>    cluster_type = string,<br>    replication_specs = object({<br>      num_shards      = number<br>      region_name     = string<br>      electable_nodes = number<br>      priority        = number<br>      read_only_nodes = number<br>    })<br>    auto_scaling_disk_gb_enabled = bool<br>    provider_name                = string # TODO: not sure if we really need to configure mongo atlas cluster provider, as we can use global variable var.provider_name. needs checking<br>    disk_size_gb                 = number<br>    provider_instance_size_name  = string<br>  })</pre> | <pre>{<br>  "auto_scaling_disk_gb_enabled": true,<br>  "cluster_type": "REPLICASET",<br>  "disk_size_gb": 100,<br>  "provider_instance_size_name": "M10",<br>  "provider_name": "AWS",<br>  "replication_specs": {<br>    "electable_nodes": 3,<br>    "num_shards": 1,<br>    "priority": 7,<br>    "read_only_nodes": 0,<br>    "region_name": "EU_CENTRAL_1"<br>  }<br>}</pre> | no |
| <a name="input_create_alert_configuration"></a> [create\_alert\_configuration](#input\_create\_alert\_configuration) | Whether to create mongodbatlas\_alert\_configuration or not. | `bool` | `true` | no |
| <a name="input_enable_auditing"></a> [enable\_auditing](#input\_enable\_auditing) | Whether to create mongodbatlas\_auditing or not. | `bool` | `false` | no |
| <a name="input_ip_addresses"></a> [ip\_addresses](#input\_ip\_addresses) | MongoDB Atlas IP Access List | `list(string)` | `[]` | no |
| <a name="input_mongo_db_major_version"></a> [mongo\_db\_major\_version](#input\_mongo\_db\_major\_version) | Mongo Atlas cluster version. | `string` | `"4.4"` | no |
| <a name="input_network_peering"></a> [network\_peering](#input\_network\_peering) | Network peering configs | <pre>list(object({<br>    accepter_region_name = string<br>    aws_account_id       = string<br>    vpc_id               = string<br>    # this option is for identifying private route table and creating route table record with target to mongodb peering, so you need to pass one of private subnets id<br>    # TODO: find better way for identifying vpc private route table, instead of using one of private subnets id<br>    subnet_id = string<br>    # IMPORTANT NOTE: this is something that you can chose from private address space and it should not overlap with VPC cidr,<br>    #  please check the following links for more info:<br>    # * https://www.mongodb.com/docs/atlas/security-vpc-peering/<br>    # * https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/network_peering<br>    # * https://datatracker.ietf.org/doc/html/rfc1918.html#section-3<br>    atlas_cidr_block = string<br>  }))</pre> | `[]` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | MongoDB Atlas Organisation ID | `string` | n/a | yes |
| <a name="input_org_invitation_enabled"></a> [org\_invitation\_enabled](#input\_org\_invitation\_enabled) | Allows to controll wheather the invitation for organization will be created | `bool` | `false` | no |
| <a name="input_policy_item_daily"></a> [policy\_item\_daily](#input\_policy\_item\_daily) | n/a | `map` | <pre>{<br>  "frequency_interval": 1,<br>  "retention_unit": "days",<br>  "retention_value": 7<br>}</pre> | no |
| <a name="input_policy_item_hourly"></a> [policy\_item\_hourly](#input\_policy\_item\_hourly) | frequency\_interval - Desired frequency of the new backup policy item specified by frequency\_type. retention\_unit - Scope of the backup policy item: days, weeks, or months. retention\_value - Value to associate with retention\_unit. | `map` | <pre>{<br>  "frequency_interval": 6,<br>  "retention_unit": "days",<br>  "retention_value": 2<br>}</pre> | no |
| <a name="input_policy_item_monthly"></a> [policy\_item\_monthly](#input\_policy\_item\_monthly) | n/a | `map` | <pre>{<br>  "frequency_interval": 40,<br>  "retention_unit": "months",<br>  "retention_value": 12<br>}</pre> | no |
| <a name="input_policy_item_weekly"></a> [policy\_item\_weekly](#input\_policy\_item\_weekly) | n/a | `map` | <pre>{<br>  "frequency_interval": 6,<br>  "retention_unit": "weeks",<br>  "retention_value": 4<br>}</pre> | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | MongoDB Atlas Project Name | `string` | `"project"` | no |
| <a name="input_provider_name"></a> [provider\_name](#input\_provider\_name) | Cloud provider to whom the peering connection is being made. | `string` | `"AWS"` | no |
| <a name="input_provider_region_name"></a> [provider\_region\_name](#input\_provider\_region\_name) | Cloud service provider on which the server for a multi-tenant cluster is provisioned, valid for only when instanceSizeName is M2 or M5. | `string` | `null` | no |
| <a name="input_schedule_restore_window_days"></a> [schedule\_restore\_window\_days](#input\_schedule\_restore\_window\_days) | Number of days back in time you can restore to with point-in-time accuracy. | `number` | `1` | no |
| <a name="input_teams"></a> [teams](#input\_teams) | n/a | <pre>list(object({<br>    team_id    = string<br>    role_names = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_use_cloud_backup_schedule"></a> [use\_cloud\_backup\_schedule](#input\_use\_cloud\_backup\_schedule) | Whether to enable automated backups. | `bool` | `false` | no |
| <a name="input_users"></a> [users](#input\_users) | MongoDB Atlas users list, roles and scopes. | `list` | <pre>[<br>  {<br>    "roles": [<br>      {<br>        "database_name": "development",<br>        "role_name": "readWrite"<br>      }<br>    ],<br>    "scopes": [<br>      {<br>        "name": "cluster",<br>        "type": "CLUSTER"<br>      }<br>    ],<br>    "username": "alice"<br>  }<br>]</pre> | no |
| <a name="input_with_default_alerts_settings"></a> [with\_default\_alerts\_settings](#input\_with\_default\_alerts\_settings) | It allows users to disable the creation of the default alert settings. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_connection_string"></a> [cluster\_connection\_string](#output\_cluster\_connection\_string) | Mongodb connecton string |
| <a name="output_users"></a> [users](#output\_users) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
