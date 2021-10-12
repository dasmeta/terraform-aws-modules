variable public_key {
  type        = string
  description = "MongoDB Atlas organisation public key"
}

variable private_key {
  type        = string
  description = "MongoDB Atlas organisation private key"
}

variable aws_account_id {
  type        = string
  description = "AWS user ID"
}

variable org_id {
  type        = string
  description = "MongoDB Atlas Organisation ID"
}

variable project_name {
  type        = string
  default     = "project"
  description = "MongoDB Atlas Project Name"
}

variable users {
  type        = list(string)
  default     = ["alice"]
  description = "MongoDB Atlas users list"
}

variable role_name {
  type        = string
  default     = "readWrite"
  description = "MongoDB Atlas users role name"
}

variable database_name {
  type        = string
  default     = "database"
  description = "MongoDB Atlas users database name"
}

variable ip_addresses {
  type        = list(string)
  default     = []
  description = "MongoDB Atlas IP Access List"
}

variable alert_event_type {
  type        = string
  default     = "OUTSIDE_METRIC_THRESHOLD"
  description = "The type of event that will trigger an alert."
}

variable alert_type_name {
  type        = string
  default     = "GROUP"
  description = "The type of alert notification."
}

variable alert_interval_min {
  type        = number
  default     = 5
  description = "Number of minutes to wait between successive notifications for unacknowledged alerts that are not resolved."
}

variable alert_delay_min {
  type        = number
  default     = 0
  description = "Number of minutes to wait after an alert condition is detected before sending out the first notification."
}

variable alert_sms_enabled {
  type        = bool
  default     = false
  description = "Flag indicating if text message notifications should be sent."
}

variable alert_email_enabled {
  type        = bool
  default     = true
  description = "Flag indicating if email notifications should be sent."
}

variable alert_roles {
  type        = list(string)
  default     = ["GROUP_CLUSTER_MANAGER", "GROUP_OWNER"]
  description = "The following roles grant privileges within a project."
}

variable alert_metric_name {
  type        = string
  default     = "NORMALIZED_SYSTEM_CPU_USER"
  description = "Name of the metric to check."
}

variable alert_operator {
  type        = string
  default     = "GREATER_THAN"
  description = "Operator to apply when checking the current metric value against the threshold value."
}

variable alert_threshold {
  type        = number
  default     = 99.0
  description = "Threshold value outside of which an alert will be triggered."
}

variable alert_units {
  type        = string
  default     = "RAW"
  description = "The units for the threshold value. Depends on the type of metric."
}

variable alert_mode {
  type        = string
  default     = "AVERAGE"
  description = "This must be set to AVERAGE. Atlas computes the current metric value as an average."
}

variable route_table_cidr_block {
  type        = string
  default     = "192.168.240.0/21"
  description = "AWS VPC CIDR block or subnet."
}

variable vpc_id {
  type        = string
  default     = "vpc-0cb8c765b4b58b790"
  description = "Unique identifier of the peer VPC."
}

variable accepter_region_name {
  type        = string
  default     = "eu-central-1"
  description = "Specifies the region where the peer VPC resides."
}

variable provider_name {
  type        = string
  default     = "AWS"
  description = "Cloud provider to whom the peering connection is being made."
}
