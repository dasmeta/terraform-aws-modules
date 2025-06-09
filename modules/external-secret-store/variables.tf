variable "name" {
  type        = string
  description = "Secret store name."
}

variable "controller" {
  type        = string
  default     = "dev"
  description = "Not sure what is this for yet."
}

variable "aws_access_key_id" {
  type        = string
  default     = ""
  description = "The key store will be using to pull secrets from AWS Secret Manager."
}

variable "aws_access_secret" {
  type        = string
  default     = ""
  description = "The secret store will be using to pull secrets from AWS Secret Manager."
}

variable "aws_role_arn" {
  type        = string
  default     = ""
  description = "Role ARN used to pull secrets from Secret Manager."
}

variable "create_user" {
  type        = bool
  default     = true
  description = "Create IAM user to read credentials or aws_access_key_id / aws_access_secret combination should be used."
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "prefix" {
  type        = string
  default     = ""
  description = "This value is going be used as uniq prefix for secret store AWS resources like iam policy/user as for multi region setups we having collision"
}

variable "external_secrets_api_version" {
  type        = string
  default     = "external-secrets.io/v1alpha1" # TODO: the new version external-secrets.io/v1beta1 is available in external-secret operator, please update to new version as soon as you upgrade operator(the new dasmeta eks module already uses the new one)
  description = "The external-secrets resource apiVersion to use when creating the resource"
}

variable "kind" {
  type        = string
  default     = "SecretStore"
  description = "kind can be SecretStore or ClusterSecretStore ,SecretStore for each namespace and ClusterSecretStore for Cluster"
}
