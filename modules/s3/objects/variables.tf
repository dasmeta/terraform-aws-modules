variable "bucket" {
  type        = string
  description = "Bucket name."
}

variable "path" {
  type        = string
  description = "Path to folder which will be pushed into bucket."
}

variable "pattern" {
  type        = string
  default     = "**"
  description = "Pattern to look for files to push to bucket."
}

variable "acl" {
  type        = string
  default     = "public-read"
  description = "ACL for files be created in S3 bucket."
}
