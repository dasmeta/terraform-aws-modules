variable "bucket_name" {
  type = string
}

variable "account_id" {
  type    = string
  default = ""
}

variable "create_bucket" {
  type    = bool
  default = true
}

variable "create_lambda" {
  type    = bool
  default = true
}
