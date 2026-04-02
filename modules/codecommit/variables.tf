variable "repository_name" {
  type        = string
  description = "Name of the repository. Must be unique within the AWS account."
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the repository."
}

variable "default_branch" {
  type        = string
  default     = null
  description = "Default branch name; the branch must already exist in the repository (for example after an initial push)."
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "ARN of the KMS key used to encrypt and decrypt repository contents; omit to use the default AWS managed key."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Key-value map of tags to assign to the repository."
}
