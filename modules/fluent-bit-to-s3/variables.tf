data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

#  User credential who have permission S3 bucket putobject
variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "aws_access_key" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "eu-central-1"
}
variable "fluent_bit_name" {
  type    = string
  default = "fluent-bit"
}

variable "cluster_name" {
  type = string
  # default     = ""
  description = "eks cluster name"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "namespace fluent-bit should be deployed into"
}

variable "create_namespace" {
  type        = bool
  default     = false
  description = "wether or no to create namespace"
}

# Auth data

variable "cluster_host" {
  type = string
}

variable "cluster_certificate" {
  type = string
}

variable "cluster_token" {
  type = string
}

variable "bucket_name" {
  type    = string
  default = "fluentbit-bucket-name"
}
