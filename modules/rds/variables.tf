variable "name" {
  type = string
}

variable "security_group_name" {
  type = string
  default = "db_security_group"
}

variable "security_group_description" {
  type = string
  default = "MySQL security group"
}

variable "tags" {
  type = map
}

variable "vpc_id" {
  type = string
}

variable "ingress_with_cidr_blocks" {
  # type = list(map(any))
  type = any
}

variable "engine" {
  type = string
  default = "mysql"
}

variable "engine_version" {
  type = string
  default = "5.7.26"
}

variable "family" {
  type = string
  default = "mysql5.7"
}

variable "major_engine_version" {
  type = string
  default = "5.7"
}

variable "instance_class" {
  type = string
  default = "db.t3.medium"
}

variable "allocated_storage" {
  type = number
  default = 20
}

variable "max_allocated_storage" {
  type = number
  default = 100
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "port" {
  type = number
  default = 3306
}

variable "multi_az" {
  type = bool
  default = true
  description = "Multiple availability zones."
}

variable "subnet_ids" {
  type = list(string)
}

variable "iam_database_authentication_enabled" {
  type = bool
  default = true
}

variable "maintenance_window" {
  type = string
  default = "Mon:00:00-Mon:03:00"
}

variable "backup_window" {
  type = string
  default = "03:00-06:00"
}

variable "enabled_cloudwatch_logs_exports" {
  type = list(string)
  default = ["general"]
}

variable "backup_retention_period" {
  type = number
  default = 0
}

variable "skip_final_snapshot" {
  type = bool
  default = true
}

variable "deletion_protection" {
  type = bool
  default = true
}

variable "create_monitoring_role" {
  type = bool
  default = true
}

variable "monitoring_interval" {
  type = number
  default = 60
}

variable "monitoring_role_name" {
  type = string
  default = "RDSMonitoringRole"
}

variable "parameters" {
  type = list(map(any))
  default = [{
      name = "character_set_client"
      value = "utf8mb4"
    },{
      name = "character_set_server"
      value = "utf8mb4"
  }, {
      max_connections = "500"
  }]
}

variable "options" {
  type = list(any)
  default = [{
    option_name = "MARIADB_AUDIT_PLUGIN"

    option_settings = [
      {
        name  = "SERVER_AUDIT_EVENTS"
        value = "CONNECT"
      },
      {
        name  = "SERVER_AUDIT_FILE_ROTATIONS"
        value = "37"
      },
    ]
  }]
}

variable "db_instance_tags" {
  type = map
  default = {}
}

variable "db_option_group_tags" {
  type = map
  default = {}
}

variable "db_parameter_group_tags" {
  type = map
  default = {}
}

variable "db_subnet_group_tags" {
  type = map
  default = {}
}

variable "apply_immediately" {
  type = bool
  default = false
}
