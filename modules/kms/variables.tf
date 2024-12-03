variable "kms_key_description" {
  description = "Description for the KMS key"
  type        = string
  default     = "KMS key for CloudWatch log group encryption"
}

variable "kms_alias_name" {
  description = "Alias name for the KMS key"
  type        = string
  default     = "cloudwatch-key"
}

variable "kms_key_cloudwatch" {
  type        = bool
  default     = true
  description = "KMS key policy for CloudWatch logs"
}

variable "kms_key_policy" {
  type        = any
  description = "KMS key policy"
  default     = null
}
