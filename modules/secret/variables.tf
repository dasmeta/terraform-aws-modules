variable "name" {
  type        = string
  description = "Secret name"
}

variable "value" {
  type        = any
  default     = null
  description = "Secret value"
}

variable "kms_key_id" {
  type        = any
  default     = null
  description = "ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret."
}

variable "recovery_window_in_days" {
  type        = number
  default     = 30
  description = "(Optional) Number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. The default value is 30"
}
