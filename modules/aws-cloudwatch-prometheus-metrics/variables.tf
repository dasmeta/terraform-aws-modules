variable "cluster_name" {
  type    = string
  default = "dasmeta-test-new2"
}

variable "namespace" {
  type    = string
  default = "amazon-cloudwatch"
}

variable "eks_oidc_root_ca_thumbprint" {
  type    = string
  default = ""
}

variable "oidc_provider_arn" {
  type    = string
  default = ""
}
