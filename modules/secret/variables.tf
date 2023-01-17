variable "name" {
  type        = string
  description = "Secret name"
}

variable "value" {
  type        = any
  default     = null
  description = "Secret value"
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "(Optional) ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key (the one named aws/secretsmanager). If the default KMS key with that name doesn't yet exist, then AWS Secrets Manager creates it for you automatically the first time."
}
