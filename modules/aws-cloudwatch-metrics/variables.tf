data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "eks cluster name"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "namespace cloudwatch metrics should be deployed into"
}

variable "create_namespace" {
  type        = bool
  default     = false
  description = "wether or no to create namespace"
}

variable "containerdSockPath" {
  type    = string
  default = "/run/dockershim.sock"
}

variable "eks_oidc_root_ca_thumbprint" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "enable_prometheus_metrics" {
  type    = bool
  default = false
}
