variable "alarm_name" {
  type        = string
  description = "Domain name or ip address of checking service."
}

variable "tags" {
  # type = object
  default     = {}
  description = "Tags object."
}
variable "alert_type_name" {
  type = string
  default = "other"
  description = "Alert_Type"
}

variable "namespace" {
  type        = string
  default     = ""
  description = "Alarm emitter."
}

variable "metric_name" {
  type        = string
  default     = ""
  description = "Name of the metric."
}
variable "comparison_operator" {
  type        = string
  default     = ""
  description = "Comparison operator."
}

variable "evaluation_periods" {
  type        = string
  default     = ""
  description = "Evaluation periods."
}

variable "period" {
  type        = string
  default     = ""
  description = "Period."
}

variable "statistic" {
  type        = string
  default     = ""
  description = "Statistic."
}

variable "threshold" {
  type        = string
  default     = ""
  description = "Threshold."
}

variable "unit" {
  type    = string
  default = ""
}

variable "dimensions" {
  type    = map(any)
  default = {}
}

variable "alarm_actions" {
  type    = list(string)
  default = []
}

variable "insufficient_data_actions" {
  type    = list(any)
  default = []
}

variable "treat_missing_data" {
  type    = string
  default = ""
}

variable "alarm_description" {
  type    = string
  default = ""
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

### Opsgenie variables
variable "opsgenie_endpoint" {
  type       = list(string)
  default    = []
  description = "Opsigenie platform integration url"
}
