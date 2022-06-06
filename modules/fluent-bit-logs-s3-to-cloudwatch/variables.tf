variable "create_lambda_s3_to_cloudwatch" {
  type    = bool
  default = true
}

variable "bucket_name" {
  type    = string
  default = "test-fluent-bit-bla"
}


variable "assume_role_arn" {
  type        = list(string)
  description = "AWS Acounts Assume roles arn which access bucket write"
  default     = ["arn:aws:iam::*:role/eks-cluster-fluent-bit-role"]
}
