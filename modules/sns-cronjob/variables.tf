variable "name" {
  type        = string
  default     = ""
  description = "Name (e.g. app or cluster)."
}

variable "description" {
  type        = string
  default     = ""
  description = "The description for the rule."
}

variable "id" {
  type        = string
  default     = true
  description = "The ARN of the SNS topic"
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-aws-sns"
  description = "Terraform current module repo"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment."
}

variable "attributes" {
  type        = list(any)
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Boolean indicating whether or not to create sns module."
}

variable "enable_topic" {
  type        = bool
  default     = true
  description = "Boolean indicating whether or not to create topic."
}

variable "display_name" {
  type        = string
  default     = ""
  description = "The display name for the SNS topic."
}

variable "policy" {
  type        = string
  default     = ""
  description = "The fully-formed AWS policy as JSON. For more information about building AWS IAM policy documents with Terraform."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags"
}

variable "protocol" {
  type        = string
  default     = ""
  description = "The protocol to use. The possible values for this are: sqs, sms, lambda, application."
}

variable "endpoint" {
  type        = string
  default     = ""
  description = "The endpoint to send data to, the contents will vary with the protocol."
}

variable "endpoint_auto_confirms" {
  type        = bool
  default     = false
  description = "Boolean indicating whether the end point is capable of auto confirming subscription."
}

variable "subscribers" {
  type = map(object({
    protocol = string
    endpoint = string
    endpoint_auto_confirms = bool 
  }))
  description = "Required configuration for subscibres to SNS topic."
  default     = {}
}

variable "schedule_expression" {
  type = any
  default = "cron(* * * * ? *)"
  description = "the aws cloudwatch event rule scheule expression that specifies when the scheduler runs. Default is 5 minuts past the hour. for debugging use 'rate(5 minutes)'. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html"
}

# variable "AutoStopSchedule" {
#    default = {
#     "1" = "cron(30 * * * ? *)"
#     "2" = "cron(0 */1 * * ? *)"
#     "3" = "cron(0 */1 * * ? *)"
#     "4" = "cron(0 */12 * * ? *)"
#     "5" = "cron(0 10 * * ? *)"
#   } 
# }