variable "cluster_oidc_issuer" {
  type = string
  description = "Cluster identity oidc issuer. Needed for tls_cert generation and oidc provider connection."
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "eks cluster name"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "namespace load balancer controller should be deployed into"
}

variable "create_namespace" {
  type        = bool
  default     = false
  description = "wether or no to create namespace"
}

variable "oidc_thumbprint_list" {
  type    = list(string)
  default = []
}

variable "iam_policy_json" {
  type = string
  default = "iam-policy.json"
}