variable "cpu_threshold" {
    type        = string
    default     = "50"
    description = "CPU Trashold"
}

variable "memory_threshold" {
    type        = string
    default     = "50"
    description = "Memory trashold"
}

variable "error_threshold" {
    type        = string
    default     = "50"
    description = "Error threshold"
}

variable "network_threshold" {
    type        = string
    default     = "50"
    description = "Network_threshold"
}
variable "dimensions" {
    type  = map(any)
    default = {} 
    description = ""
}
variable "service_name" {
    type = string
    default = "Service"
    description = "Service Name"
}
variable "namespace" {
  type = string
  description = "Service Namespace"
}

variable "create_dashboard" {
  type        = bool
  default     = true
  description = "If you create dashboard input yes otherwise no"  
}

variable "log_group_name" {
    type = string
    description = "Metric filter create in log group."
}

### SNS Topic related variables
variable "sns_subscription_email_address_list" {
  type        = list(string)
  default     = []
  description = "List of email addresses"
}

variable "sns_subscription_phone_number_list" {
  type        = list(string)
  default     = []
  description = "List of telephone numbers to subscribe to SNS."
}

variable "sms_message_body" {
  type    = string
  default = "sms_message_body"
}

### Slack variables
variable "slack_hook_url" {
  type        = string
  default     = ""
  description = "This is slack webhook url path without domain"
}

variable "slack_channel" {
  type        = string
  default     = ""
  description = "Slack Channel"
}

variable "slack_username" {
  type        = string
  default     = ""
  description = "Slack User Name"
}
variable "cluster_name" {
  type        = string
  description = "Cluser Name"  
}
