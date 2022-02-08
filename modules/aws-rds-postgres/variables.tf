variable "name" {
  type = string
}

variable "database" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ip_ranges" {
  type    = list(string)
  default = []
}

variable "storage" {
  type        = number
  default     = 20
  description = "Storage voluem size - cannot be decreased after creation"
}

variable "backup_retention_period" {
  type        = number
  default     = 7
  description = "Number of days backups will be kept"
}

variable "instance_class" {
  type        = string
  default     = "db.t2.micro"
  description = "Underlaying ec2 instance class"
}

variable "engine_version" {
  type        = string
  default     = "11.12"
  description = "Postgres engine version"
}
variable "monitoring_role_name" {
  type        = string
  default     = "MyRDSMonitoringRole"
  description = "IAM Role name"
}
variable "create_security_group" {
  type        = bool
  default     = true
  description = "Create Security group"
}
variable "security_group_ids" {
  type        = list(string)
  default     = [""]
  description = "Security group name"
}
variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}
variable "db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC"
  type        = string
  default     = null
}
variable "create_db_subnet_group" {
  type    = bool
  default = true
}


