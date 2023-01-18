variable "create_lambda_s3_to_cloudwatch" {
  type    = bool
  default = true
}

variable "bucket_name" {
  type    = string
  default = "test-fluent-bit-bla"
}

variable "create_bucket" {
  type    = bool
  default = true
}

variable "assume_role_arn" {
  type        = list(string)
  description = "AWS Acounts Assume roles arn which access bucket write"
  default     = ["arn:aws:iam::*:role/eks-cluster-fluent-bit-role"]
}

variable "sse_algorithm" {
  type        = string
  default     = "aws:kms"
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
