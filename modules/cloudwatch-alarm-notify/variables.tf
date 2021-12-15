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
  description = "Alert_Type"
}

variable "alert_variables" {
  type = any
  default = {
    k8s_alerts = {}
    alb_alerts = {}
    other_alerts = {}
  }
}

variable "default_alerts_variables" {
  type        = any
  description  = "Default value"
  default     = {     
      k8s_alerts = {
          comparison_operator    = "GreaterThanOrEqualToThreshold"
          evaluation_periods     = "1"
          period                 = "300"
          namespace              = "ContainerInsights"
          unit                   = "Percent"
          metric_name            = "pod_cpu_utilization"
          statistic              = "Average"
          threshold              = "25"
          alarm_description_up   = "Pod mongodb-replicaset-prod-0 CPU usage < 25"
          alarm_description_down = "Pod mongodb-replicaset-prod-0 CPU usage > 25"
          treat_missing_data     = "notBreaching"
          dimensions             = {
            "ClusterName" = "prod-6"
            "PodName"     = "mongodb-replicaset-prod-0"
            "Namespace"   = "default"
          }
          insufficient_data_actions = []
      },
      alb_alerts = {
          comparison_operator    = "GreaterThanOrEqualToThreshold"
          evaluation_periods     = "1"
          period                 = "60"
          namespace              = "AWS/ApplicationELB"
          unit                   = "Count"
          metric_name            = "HTTPCode_ELB_5XX_Count"
          statistic              = "Sum"
          threshold              = "20"
          alarm_description_up   = "ALB httpcode elb 5xx count < 20."
          alarm_description_down = "ALB httpcode elb 5xx count => 20."
          treat_missing_data     = "notBreaching"
          insufficient_data_actions = []
          dimensions             = {
            LoadBalancer = "app/faf95412-default-mainingre-8687/cd94bc3e3dc4979f"
          }
      }
      other_alerts = {
          comparison_operator    = ""
          evaluation_periods     = ""
          period                 = ""
          namespace              = ""
          unit                   = ""
          metric_name            = ""
          statistic              = ""
          threshold              = ""
          alarm_description_up   = ""
          alarm_description_down = ""
          treat_missing_data     = ""
          insufficient_data_actions = []
          dimensions             = {}
      }
  }
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
  default     = ""
}

variable "slack_channel" {
  type        = string
  description = "Slack Channel"
  default     = ""
}

variable "slack_username" {
  type        = string
  description = "Slack User Name"
  default     = ""
}
