data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

variable "fluent_bit_name" {
  type = string
  default = "fluent-bit"
}

variable "cluster_name" {
  type        = string
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

variable "eks_oidc_root_ca_thumbprint" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
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

variable "log_group_name" {
  type = string
  default = ""
}
