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
