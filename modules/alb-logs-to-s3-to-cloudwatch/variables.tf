variable "alb_log_bucket_name" {
  type = string
}

variable "create_alb_log_bucket" {
  type        = bool
  default     = true
  description = "wether or no to create alb s3 logs bucket"
}

variable "create_lambda" {
  type    = bool
  default = true
}

variable "alb_log_bucket_prefix" {
  type    = string
  default = ""
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Default region"
}
variable "account_id" {
  type    = string
  default = ""
}
