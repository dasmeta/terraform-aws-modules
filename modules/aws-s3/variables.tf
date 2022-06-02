variable "bucket_name" {
  type    = string
  default = "test-dasmeta-test-new2-fluent-bit"
}

variable "assume_role_arn" {
  type        = list(string)
  description = "AWS Acounts Assume roles arn which access bucket write"
  default     = ["arn:aws:iam::5*:role/dasmeta-test-new2-fluent-bit"]
}
