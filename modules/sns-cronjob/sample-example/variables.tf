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

variable "enabled" {
  type        = bool
  default     = true
  description = "Boolean indicating whether or not to create sns module."
}

variable "schedule_expression" {
  type = any
  default = "cron(* * * * ? *)"
  description = "the aws cloudwatch event rule scheule expression that specifies when the scheduler runs. Default is 5 minuts past the hour. for debugging use 'rate(5 minutes)'. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html"
}
