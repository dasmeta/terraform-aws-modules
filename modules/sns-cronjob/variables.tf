variable "name" {
  type        = string
  description = "Name (e.g. app or cluster)."
}

variable "endpoint" {
  type        = string
  description = "The endpoint to send POST request data to, the contents will vary with the protocol."
}

variable "is_enabled" {
  type        = bool
  default     = true
  description = "Controls if cronjob enabled or not"
}

variable "input" {
  type        = any
  default     = {}
  description = "The data, input to set into POST request body Message field."
}

variable "schedule" {
  type        = any
  default     = "cron(* * * * ? *)"
  description = "the aws cloudwatch event rule schedule expression that specifies when the scheduler runs. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html"
}

variable "success_sample_percentage" {
  type        = string
  default     = 100
  description = "Percentage of success to sample"
}

variable "kms_master_key_id" {
  type        = string
  default     = "alias/aws/sns"
  description = "(Optional) The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK. For more information, see Key Terms"
}

variable "kms_data_key_reuse_period_seconds" {
  type         = number
  default      = 300
  descrription = "(Optional) The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours). The default is 300 (5 minutes)."
}
