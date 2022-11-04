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

variable "create_security_group" {
  type    = bool
  default = false
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

variable "security_group_name" {
  type    = string
  default = "RabbitMQ security group name."
}

variable "security_group_description" {
  type    = string
  default = "RabbitMQ security group description."
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "ingress_with_cidr_blocks" {
  type    = list(map(string))
  default = []
}
