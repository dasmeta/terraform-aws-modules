variable "public_key" {
  type        = string
  description = "MongoDB Atlas organisation public key"
}

variable "private_key" {
  type        = string
  description = "MongoDB Atlas organisation private key"
}

variable "aws_account_id" {
  type        = string
  description = "AWS user ID"
}

variable "org_id" {
  type        = string
  description = "MongoDB Atlas Organisation ID"
}

variable "project_name" {
  type        = string
  default     = "project"
  description = "MongoDB Atlas Project Name"
}

variable "users" {
  default = [
    {
      username = "alice",
      roles = [
        {
          database_name = "development"
          role_name     = "readWrite"
        },
      ]
      scopes = [
        {
          name = "cluster"
          type = "CLUSTER"
        },
      ]
    }
  ]
  description = "MongoDB Atlas users list, roles and scopes."
}

variable "ip_addresses" {
  type        = list(string)
  default     = []
  description = "MongoDB Atlas IP Access List"
}

variable "alert_event_type" {
  type        = string
  default     = "OUTSIDE_METRIC_THRESHOLD"
  description = "The type of event that will trigger an alert."
}

variable "alert_type_name" {
  type        = string
  default     = "GROUP"
  description = "The type of alert notification."
}

variable "alert_interval_min" {
  type        = number
  default     = 5
  description = "Number of minutes to wait between successive notifications for unacknowledged alerts that are not resolved."
}

variable "alert_delay_min" {
  type        = number
  default     = 0
  description = "Number of minutes to wait after an alert condition is detected before sending out the first notification."
}

variable "alert_sms_enabled" {
  type        = bool
  default     = false
  description = "Flag indicating if text message notifications should be sent."
}

variable "alert_email_enabled" {
  type        = bool
  default     = true
  description = "Flag indicating if email notifications should be sent."
}

variable "alert_roles" {
  type        = list(string)
  default     = ["GROUP_CLUSTER_MANAGER", "GROUP_OWNER"]
  description = "The following roles grant privileges within a project."
}

variable "alert_metric_name" {
  type        = string
  default     = "NORMALIZED_SYSTEM_CPU_USER"
  description = "Name of the metric to check."
}

variable "alert_operator" {
  type        = string
  default     = "GREATER_THAN"
  description = "Operator to apply when checking the current metric value against the threshold value."
}

variable "alert_threshold" {
  type        = number
  default     = 99.0
  description = "Threshold value outside of which an alert will be triggered."
}

variable "alert_units" {
  type        = string
  default     = "RAW"
  description = "The units for the threshold value. Depends on the type of metric."
}

variable "alert_mode" {
  type        = string
  default     = "AVERAGE"
  description = "This must be set to AVERAGE. Atlas computes the current metric value as an average."
}

variable "route_table_cidr_block" {
  type        = string
  default     = "192.168.240.0/21"
  description = "AWS VPC CIDR block or subnet."
}

variable "vpc_id" {
  type        = string
  default     = "vpc-0cb8c765b4b58b790"
  description = "Unique identifier of the peer VPC."
}

variable "accepter_region_name" {
  type        = string
  default     = "eu-central-1"
  description = "Specifies the region where the peer VPC resides."
}

variable "provider_name" {
  type        = string
  default     = "AWS"
  description = "Cloud provider to whom the peering connection is being made."
}

variable "access_users" {
  type = list(object({
    username      = string,
    roles         = list(string),
    project_roles = set(string)
  }))
  default     = []
  description = "Access Users"
}

variable "org_invitation_enabled" {
  type        = bool
  default     = false
  description = "Allows to controll wheather the invitation for organization will be created"
}

variable "team_roles" {
  type        = list(string)
  default     = null
  description = "Project roles assigned to the team."
}

variable "team_id" {
  type        = string
  default     = null
  description = "The unique identifier of the team which will be associated with the project."
}

variable "policy_item_hourly" {
  default = {
    frequency_interval = 6
    retention_unit     = "days"
    retention_value    = 2
  }
  description = "frequency_interval - Desired frequency of the new backup policy item specified by frequency_type. retention_unit - Scope of the backup policy item: days, weeks, or months. retention_value - Value to associate with retention_unit."
}

variable "policy_item_daily" {
  default = {
    frequency_interval = 1
    retention_unit     = "days"
    retention_value    = 7
  }
}

variable "policy_item_weekly" {
  default = {
    frequency_interval = 6
    retention_unit     = "weeks"
    retention_value    = 4
  }
}

variable "policy_item_monthly" {
  default = {
    frequency_interval = 40
    retention_unit     = "months"
    retention_value    = 12
  }
}

variable "use_cloud_provider_snapshot_backup_policy" {
  type        = bool
  default     = false
  description = "mongodbatlas_cloud_provider_snapshot_backup_policy is deprecated, but make use_cloud_provider_snapshot_backup_policy true to use this resource."
}

variable "use_cloud_backup_schedule" {
  type        = bool
  default     = true
  description = "As use_cloud_provider_snapshot_backup_policy is deprecated, this resource should be used, but it can't be used with the other one, so only one of these must be true."
}

variable "cloud_backup" {
  type        = bool
  default     = true
  description = "Enable Cloud Backup."
}

variable "with_default_alerts_settings" {
  type        = bool
  default     = true
  description = "It allows users to disable the creation of the default alert settings."
}

variable "teams" {
  default = {
    team_id    = null
    role_names = null
  }
  description = "team_id - The unique identifier of the team you want to associate with the project. role_names - Each string in the array represents a project role you want to assign to the team. Every user associated with the team inherits these roles."
}

variable "create_alert_configuration" {
  type        = bool
  default     = true
  description = "Whether to create mongodbatlas_alert_configuration or not."
}

variable "enable_auditing" {
  type        = bool
  default     = false
  description = "Whether to create mongodbatlas_auditing or not."
}

variable "audit_filter" {
  default = {
    "$or" : [
      {
        "users" : []
      },
      {
        "$and" : [
          {
            "$or" : [
              {
                "users" : {
                  "$elemMatch" : {
                    "$or" : [
                      {
                        "db" : "admin"
                      },
                      {
                        "db" : "$external"
                      }
                    ]
                  }
                }
              },
              {
                "roles" : {
                  "$elemMatch" : {
                    "$or" : [
                      {
                        "db" : "admin"
                      }
                    ]
                  }
                }
              }
            ]
          },
          {
            "$or" : [
              {
                "atype" : "authCheck",
                "param.command" : {
                  "$in" : [
                    "aggregate",
                    "count",
                    "distinct",
                    "group",
                    "mapReduce",
                    "geoNear",
                    "geoSearch",
                    "eval",
                    "find",
                    "getLastError",
                    "getMore",
                    "getPrevError",
                    "parallelCollectionScan",
                    "delete",
                    "findAndModify",
                    "insert",
                    "update",
                    "resetError"
                  ]
                }
              },
              {
                "atype" : {
                  "$in" : [
                    "authenticate",
                    "createCollection",
                    "createDatabase",
                    "createIndex",
                    "renameCollection",
                    "dropCollection",
                    "dropDatabase",
                    "dropIndex",
                    "createUser",
                    "dropUser",
                    "dropAllUsersFromDatabase",
                    "updateUser",
                    "grantRolesToUser",
                    "revokeRolesFromUser",
                    "createRole",
                    "updateRole",
                    "dropRole",
                    "dropAllRolesFromDatabase",
                    "grantRolesToRole",
                    "revokeRolesFromRole",
                    "grantPrivilegesToRole",
                    "revokePrivilegesFromRole",
                    "enableSharding",
                    "shardCollection",
                    "addShard",
                    "removeShard",
                    "shutdown",
                    "applicationMessage"
                  ]
                }
              }
            ]
          }
        ]
      }
    ]
  }
  description = "JSON-formatted audit filter. All filters are chosen by default."
}

variable "schedule_restore_window_days" {
  type        = number
  default     = 1
  description = "Number of days back in time you can restore to with point-in-time accuracy."
}
