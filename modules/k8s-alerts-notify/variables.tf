variable "pod_name" {
  type        = string
  description = "Domain name or ip address of checking service."
}

variable "tags" {
  # type = object
  default     = {}
  description = "Tags object."
}

variable "namespace" {
  type        = string
  default     = "ContainerInsights"
  description = "Alarm emitter."
}

variable "metric_name" {
  type        = string
  default     = "pod_number_of_container_restarts"
  description = "Name of the metric."
}

variable "comparison_operator" {
  type        = string
  default     = "GreaterThanOrEqualToThreshold"
  description = "Comparison operator."
}

variable "evaluation_periods" {
  type        = string
  default     = "1"
  description = "Evaluation periods."
}

variable "period" {
  type        = string
  default     = "60"
  description = "Period."
}

variable "statistic" {
  type        = string
  default     = "Maximum"
  description = "Statistic."
}

variable "threshold" {
  type        = string
  default     = "1"
  description = "Threshold."
}

variable "unit" {
  type    = string
  default = "Count"
}

variable "dimensions" {
  type    = map(any)
  default = {}
}

variable "alarm_description_down" {
  type    = string
  default = "This metric monitors pod restarts."
}
variable "alarm_description_up" {
  type    = string
  default = "This metric monitors pod restarts."
}
variable "alarm_actions" {
  type    = list(string)
  default = []
}

variable "insufficient_data_actions" {
  type    = string
  default = "breaching"
}

variable "depends" {
  default = []
}


### SNS Topic related variables
variable "topic_name" {
  type        = string
  default     = "topic"
  description = "SNS topic name."
}

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
  description = "This is slack webhook url path without domain"
}

variable "slack_channel" {
  type        = string
  description = "Slack Channel"
}

variable "slack_username" {
  type        = string
  description = "Slack User Name"
}
