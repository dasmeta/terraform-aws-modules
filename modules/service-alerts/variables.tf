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

variable "restart_count" {
  type    = string 
  default = "10"
  description = "Restart Count"
}

variable "error_threshold" {
    type        = string
    default     = "10"
    description = "Error threshold"
}

variable "network_threshold" {
    type        = string
    default     = "50"
    description = "Network_threshold"
}

variable "pod_name" {
    type = string
    description = "Service Name"
}

variable "cluster_name" {
  type        = string
  description = "Cluser Name"  
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

variable "error_filter" {
  type = bool
  default =  true
  description = "Create error log or no"
}

variable "log_group_name" {
    type = string
    default = ""
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
