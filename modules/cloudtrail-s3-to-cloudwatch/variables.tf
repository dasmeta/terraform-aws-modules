variable "create_lambda_s3_to_cloudwatch" {
  type        = bool
  default     = true
  description = "Will create Lambda which will push s3 logs into CloudWatch."
}

variable "bucket_name" {
  type        = string
  default     = "test-fluent-bit-bla"
  description = "Whatever bucket CloudTrail logs will be pushed into. Works cross account."
}

variable "account_id" {
  type        = string
  default     = ""
  description = "AWS Account ID logs will be pushed from. Will take default account_id if nothing provided."
}

variable "cloudtrail_name" {
  type        = string
  description = "CloudTrail name logs will be pushed from. Used to setup permissions on Bucket to accept logs from."
}

variable "cloudtrail_region" {
  type        = string
  default     = ""
  description = "The region CloudTrail reside. Used to to setup permissions on Bucket to accept logs from. Defaults to current region if non provided."
}

variable "kms_key_id" {
  type        = string
  default     = ""
  description = "(Optional) The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested."
}

variable "sse_algorithm" {
  type        = string
  default     = null
  description = "(Required) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "(Required) Boolean which indicates if this criteria is enabled."
}
