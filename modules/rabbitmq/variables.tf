variable "broker_name" {
  type = string
}

variable "engine_type" {
  type    = string
  default = "RabbitMQ"
}

variable "engine_version" {
  type    = string
  default = "3.8.11"
}

variable "storage_type" {
  type    = string
  default = "ebs"
}

variable "host_instance_type" {
  type    = string
  default = "mq.m5.large"
  # the most cheap type is mq.m5.large on multi az deployment mode, mq.t3.micro is available on SINGLE_INSTANCE deployment mode.
}

variable "deployment_mode" {
  type    = string
  default = "CLUSTER_MULTI_AZ"
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "subnet_ids" {
  type = any # may be one element or multiple depending on deployment_mode attribute
}

variable "security_groups" {
  type = list(string)
}

variable "auto_minor_version_upgrade" {
  type    = bool
  default = true
}

# variable "enable_cloudwatch_logs" {
#   type = bool
#   default = true
# }

variable "mw_day_of_week" {
  type    = string
  default = "SUNDAY"
}

variable "mw_time_of_day" {
  type    = string
  default = "03:00"
}

variable "mw_time_zone" {
  type    = string
  default = "UTC"
}

variable "username" {
  type = string
}

variable "password" {
  type = string
  # sensitive = true
}

variable "tags" {
  type    = map(any)
  default = {}
}

# broker_name = "kalgera-broker-stage"

# engine_type        = "RabbitMQ"
# engine_version     = "3.8.11"
# storage_type       = "ebs"

# the most cheap type is mq.m5.large on multi az deployment mode, mq.t3.micro is available on SINGLE_INSTANCE deployment mode.
# host_instance_type = "mq.m5.large"
# deployment_mode     = "CLUSTER_MULTI_AZ"
# publicly_accessible = false
# subnet_ids          = module.prod_complete_cluster.vpc_private_subnets
# security_groups     = [ module.prod_complete_cluster.cluster_primary_security_group_id ]

# auto_minor_version_upgrade = true

# logs {
#   general = true
# }

# maintenance_window_start_time {
#   day_of_week = "SUNDAY"
#   time_of_day = "03:00 - 05:00"
#   time_zone = "UTC"
# }

# user {
#   username = "kalgeramq"
#   password = "kalgeramq123$"
# }
