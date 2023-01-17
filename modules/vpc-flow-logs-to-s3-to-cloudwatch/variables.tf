variable "create_lambda_s3_to_cloudwatch" {
  type    = bool
  default = true
}

variable "create_bucket" {
  type    = bool
  default = true
}

variable "bucket_name" {
  type    = string
  default = ""
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
  type    = bool
  default = true
}
