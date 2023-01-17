variable "bucket_name" {
  type        = string
  description = "Name of the bucket module will create for CloudFront to stream logs to. Will default to account_id-cloudfront-logs."
  default     = ""
}

variable "account_id" {
  type        = string
  default     = ""
  description = "Remote AWS Account id to stream logs to. If left empty current account will be used."
}

variable "create_bucket" {
  type        = bool
  default     = true
  description = "Defines if the module should create the bucket or use one specified."
}

variable "create_lambda" {
  type        = bool
  default     = true
  description = "If enabled lambda will be created which will stream logs from S3 into CloudWatch."
}

variable "kms_key_id" {
  type        = string
  default     = ""
  description = "(Optional) The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "(Required) Boolean which indicates if this criteria is enabled."
}

variable "sse_algorithm" {
  type        = string
  default     = null
  description = "(Required) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
}
