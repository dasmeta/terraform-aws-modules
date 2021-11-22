### Healthcheck related vaiables
variable "domain_name" {
  type = string
  description = "Domain name or ip address of checking service."
}

variable "port" {
  type = number
  default = 443
  description = "Port number of checking service."
}

variable "type" {
  type = string
  default = "HTTPS"
  description = "Type of health check."
}

variable "reference_name" {
  type = string
  default = ""
  description = "Reference name of health check."
}

variable "resource_path" {
  type = string
  default = ""
  description = "Path name coming after fqdn."
}

variable "alarm_region" {
  type = string
  default = "eu-central-1"
  description = "Region from where the alarms must be monitored. All regions are taken if the value is omited."
}

variable "failure_threshold" {
  type = string
  default = "5"
  description = "The number of consecutive health checks that an endpoint must pass or fail."
}

variable "request_interval" {
  type = string
  default = "30"
  description = "The number of seconds between the time that Amazon Route 53 gets a response from your endpoint and the time that it sends the next health-check request."
}

variable "tags" {
  # type = object
  default = {}
  description = "Tags object."
}

variable "namespace" {
  type = string
  default = "AWS/Route53"
  description = "Alarm emitter."
}

variable "metric_name" {
  type = string
  default = "HealthCheckStatus"
  description = "Name of the metric."
}

variable "comparison_operator" {
  type = string
  default = "LessThanThreshold"
  description = "Comparison operator."
}

variable "evaluation_periods" {
  type = string
  default = "1"
  description = "Evaluation periods."
}

variable "period" {
  type = string
  default = "60"
  description = "Period."
}

variable "statistic" {
  type = string
  default = "Minimum"
  description = "Statistic."
}

variable "threshold" {
  type = string
  default = "1"
  description = "Threshold."
}

variable "unit" {
  type = string
  default = "None"
}

variable "dimensions" {
  default = {}
}

variable "alarm_description_down" {
  type = string
  default = "This metric monitors whether the service endpoint is down or not."
}
variable "alarm_description_up" {
  type = string
  default = "This metric monitors whether the service endpoint is up"
}
variable "alarm_actions" {
  type = list(string)
  default = []
}

variable "insufficient_data_actions" {
  type = string
  default = "breaching"
}

variable "depends" {
  default = []
}


### SNS Topic related variables
variable "topic_name" {
  type = string
  default = "topic"
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
  type = string
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
