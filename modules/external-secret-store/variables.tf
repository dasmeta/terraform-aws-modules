variable "name" {
  type        = string
  description = "Secret store name. The store's IAM role is scoped to AWS Secrets Manager secrets whose name starts with this value (e.g. \"app/prod\" -> \"app/prod*\")."
}

variable "controller_role_arn" {
  type        = string
  description = "ARN of the external-secrets controller's base IAM role. The store role trusts this principal so the controller can assume it (role chaining via spec.provider.aws.role). No static credentials are used."
}

variable "kind" {
  type        = string
  default     = "SecretStore"
  description = "SecretStore (namespaced) or ClusterSecretStore (cluster-wide)."

  validation {
    condition     = contains(["SecretStore", "ClusterSecretStore"], var.kind)
    error_message = "kind must be SecretStore or ClusterSecretStore."
  }
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "Namespace for a SecretStore (ignored for ClusterSecretStore)."
}

variable "region" {
  type        = string
  default     = ""
  description = "AWS region for the SecretsManager provider; defaults to the current region when empty."
}

variable "external_secrets_api_version" {
  type        = string
  default     = "external-secrets.io/v1"
  description = "apiVersion for the SecretStore/ClusterSecretStore resource (chart 2.8.0 ships external-secrets.io/v1)."
}

variable "prefix" {
  type        = string
  default     = ""
  description = "Uniqueness prefix for the store's global IAM role name (needed for multi-region setups since IAM is global)."
}

variable "store_role_name_prefix" {
  type        = string
  default     = "external-secrets-store-"
  description = "Naming prefix for the store IAM role. Must match the controller's store_role_name_prefix so the controller's sts:AssumeRole grant covers it."
}
