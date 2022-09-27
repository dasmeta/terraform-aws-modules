variable "set_account_settings" {
  type        = bool
  default     = false
  description = "The account setting is important to have per account region level set before enabling logging as it have important setting set for cloudwatch role arn, also cloudwatch role should be created before enabling setting"
}

variable "create_cloudwatch_log_role" {
  type        = bool
  default     = false
  description = "This allows to create cloudwatch role which is one per aws account and is not region specific"
}