variable "create_user" {
  description = "Whether to create the IAM user"
  type        = bool
  default     = true
}

variable "console" {
  description = "Whether to create IAM user login profile"
  type        = bool
  default     = true
}

variable "api" {
  description = "Whether to create IAM access key"
  type        = bool
  default     = true
}

variable "username" {
  description = "Desired name for the IAM user"
  type        = string
}

variable "policy_attachment" {
  type        = list(string)
  default     = []
  description = "The list of ARN-s of the policy you want to apply"
}

variable "pgp_key" {
  description = "Either a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Used to encrypt password and access key. `pgp_key` is required when `create_iam_user_login_profile` is set to `true`"
  type        = string
  default     = ""
}

variable "policy" {
  description = "IAM policy resource"
  type        = any
  default     = null
}

variable "create_policy" {
  description = "Whether create a policy or not."
  type        = bool
  default     = true
}
