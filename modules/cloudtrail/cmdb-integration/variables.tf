variable "name" {
  type        = string
  description = "Lambda name"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket for s3 subscription"
}

variable "cmdb_integration_config" {
  type = object({
    subscriptions = optional(list(object({
      protocol               = optional(string, null)
      endpoint               = optional(string, null)
      endpoint_auto_confirms = optional(bool, false)
    dead_letter_queue_arn = optional(string) })), [])
    environment_variables = optional(map(any), {})
  })
  default     = {}
  description = "CMDB Integration Config"
}

# variable "uniq_id" {
#   description = "Unique string to set as prefix on lambda function name"
#   type        = string
#   default     = ""
# }

# variable "role_name" {
#   description = "In case if we have already created role for function we can pass it"
#   type        = string
#   default     = null
# }

# variable "create_role" {
#   description = "Whether to create lambda role or not"
#   type        = bool
#   default     = true
# }

# variable "memory_size" {
#   description = "Memory size for Lambda function"
#   type        = number
#   default     = null
# }

# variable "timeout" {
#   description = "Timeout for Lambda function"
#   type        = number
#   default     = null
# }

# variable "sns_subscription" {
#   type        = bool
#   default     = true
#   description = "Enable SNS subsription"
# }

# variable "log_group_retention_days" {
#   type        = number
#   description = "The retention days for cloudwatch log group"
#   default     = 7
# }

# # variable "dead_letter_queue_arn" {
# #   type        = string
# #   description = "The SQS queue arn for using as dead letter"
# #   default     = null
# # }

# # variable "attach_dead_letter_policy" {
# #   type        = bool
# #   description = "Whether to attach dead letter queue"
# #   default     = false
# # }

# variable "recreate_missing_package" {
#   type        = bool
#   default     = true
#   description = "Whether to recreate missing Lambda package if it is missing locally or not"
# }

# variable "runtime" {
#   type        = string
#   default     = "nodejs14.x"
#   description = "Runtime"
# }

# variable "s3_bucket" {
#   type        = string
#   default     = null
#   description = "S3 bucket for s3 subscription"
# }
