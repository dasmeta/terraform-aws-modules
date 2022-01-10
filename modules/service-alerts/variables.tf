# CPU
variable "enable_cpu_threshold" {
  type = bool
  default =  true
  description = "Enable cpu threshold or no"
}

variable "cpu_threshold" {
  type        = string
  default     = "50"
  description = "CPU Trashold"
}

variable "cpu_unit" {
  type = string
  default =  "Percent"
  description = "CPU Unit"
}

variable "cpu_period" {
  type = string
  default =  "300"
  description = "CPU Period"
}

variable "cpu_statistic" {
  type = string
  default = "Average"
  description = "CPU Statistic"
}

# MEMORY

variable "enable_memory_threshold" {
  type = bool
  default =  true
  description = "Enable memory threshold or no"
}

variable "memory_threshold" {
    type        = string
    default     = "50"
    description = "Memory Trashold"
}

variable "memory_unit" {
  type = string
  default =  "Percent"
  description = "Memory Unit"
}

variable "memory_period" {
  type = string
  default =  "300"
  description = "Memory Period"
}

variable "memory_statistic" {
  type = string
  default = "Average"
  description = "Memory Statistic"
}

# RESTART
variable "enable_restart_count" {
  type = bool
  default =  true
  description = "Enable restart threshold or no"
}

variable "restart_count" {
  type    = string 
  default = "10"
  description = "Restart Count"
}

variable "restart_period" {
  type = string
  default =  "60"
  description = "Restart Period"
}

variable "restart_statistic" {
  type = string
  default =  "Maximum"
  description = "Restart Statistic"
}

variable "restart_unit" {
  type = string
  default =  "Count"
  description = "Restart Unit"
} 


#Error Filter
variable "enable_error_filter" {
  type = bool
  default =  true
  description = "Enable error log or no"
}

variable "error_filter_pattern" {
  type = string
  default = "Error"
  description = "Log group error filter pattern"
}

variable "log_group_name" {
    type = string
    default = ""
    description = "Metric filter create in log group."
}

variable "error_threshold" {
    type        = string
    default     = "10"
    description = "Error threshold"
}

variable "error_unit" {
  type = string
  default =  "Percent"
  description = "Error Unit"
} 

variable "error_statistic" {
  type = string
  default =  "Sum"
  description = "Error Statistic"
} 

variable "error_period" {
  type = string
  default =  "3600"
  description = "Error Period"
} 

# Network 
variable "enable_network_threshold" {
  type = bool
  default =  true
  description = "Enable network threshold or no"
}

variable "network_threshold" {
    type        = string
    default     = "50"
    description = "Networ Threshold"
}

variable "network_unit" {
  type = string
  default =  "Percent"
  description = "Network Unit"
} 

variable "network_statistic" {
    type        = string
    default     = "Average"
    description = "Network Statistic"
}

variable "network_period" {
    type        = string
    default     = "300"
    description = "Network Period"
}

#Dimension
variable "pod_name" {
    type = string
    description = "Pod Name"
}

variable "cluster_name" {
  type        = string
  description = "Cluser Name"  
}

variable "namespace" {
  type = string
  description = "Pod Namespace"
}

# Dashboard
variable "create_dashboard" {
  type        = bool
  default     = true
  description = "If you create dashboard input yes otherwise no"  
}

variable "dashboard_region" {
  type        = string
  default     = "us-east-1"
  description = "If you create dashboard input yes otherwise no"  
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
