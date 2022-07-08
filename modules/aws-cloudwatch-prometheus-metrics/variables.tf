variable "namespace" {
  type    = string
  default = "amazon-cloudwatch"
}

variable "eks_oidc_root_ca_thumbprint" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "eks cluster name"
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
