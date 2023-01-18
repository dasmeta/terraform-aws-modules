variable "alb_log_bucket_name" {
  type = string
}

variable "create_alb_log_bucket" {
  type        = bool
  default     = true
  description = "wether or no to create alb s3 logs bucket"
}

variable "create_lambda" {
  type    = bool
  default = true
}

variable "alb_log_bucket_prefix" {
  type    = string
  default = ""
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Default region"
}

variable "account_id" {
  type    = string
  default = ""
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = " (Optional) The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested."
}

variable "sse_algorithm" {
  type        = string
  default     = null
  description = "sse_algorithm - (Required) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
}

variable "enabled" {
  type        = bool
  default     = false
  description = "enabled"
}

variable "logging" {
  type        = list(any)
  default     = []
  description = "logging"
}
