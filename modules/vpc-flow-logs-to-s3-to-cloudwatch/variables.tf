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
