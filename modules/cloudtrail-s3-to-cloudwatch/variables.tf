variable "create_lambda_s3_to_cloudwatch" {
  type    = bool
  default = true
}

variable "bucket_name" {
  type    = string
  default = "test-fluent-bit-bla"
}

variable "account_id" {
  type    = string
  default = ""
}

variable "cloudtrail_name" {
  type = string
}

variable "cloudtrail_region" {
  type    = string
  default = "us-east-1"
}
