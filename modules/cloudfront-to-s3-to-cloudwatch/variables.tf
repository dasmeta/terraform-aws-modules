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
