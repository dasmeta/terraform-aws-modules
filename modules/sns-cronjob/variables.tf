variable "name" {
  type        = string
  default     = ""
  description = "Name (e.g. app or cluster)."
}

# variable "protocol" {
#   type        = string
#   default     = ""
#   description = "The protocol to use. The possible values for this are: sqs, sms, lambda, application."
# }

# variable "endpoint" {
#   type        = string
#   default     = ""
#   description = "The endpoint to send data to, the contents will vary with the protocol."
# }

# variable "endpoint_auto_confirms" {
#   type        = bool
#   default     = false
#   description = "Boolean indicating whether the end point is capable of auto confirming subscription."
# }

# variable "subscribers" {
#   type = any
#   description = "Required configuration for subscibres to SNS topic."
#   default     = {}
# }

variable "schedule_expression" {
  type = any
  default = "cron(* * * * ? *)"
  description = "the aws cloudwatch event rule scheule expression that specifies when the scheduler runs. Default is 5 minuts past the hour. for debugging use 'rate(5 minutes)'. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html"
}
