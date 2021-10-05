variable "create_user" {
  description = "Whether to create the IAM user"
  type        = bool
  default     = true
}

variable "create_iam_user_login_profile" {
  description = "Whether to create IAM user login profile"
  type        = bool
  default     = true
}

variable "create_iam_access_key" {
  description = "Whether to create IAM access key"
  type        = bool
  default     = true
}

variable "user-name" {
  description = "Desired name for the IAM user"
  type        = string
}

variable "policy-arn" {
  type      = list(string)
  default   = [
              "arn:aws:iam::aws:policy/ReadOnlyAccess", 
              "arn:aws:iam::aws:policy/IAMUserChangePassword"
            ]
  description = "IAM user name"
}

variable "pgp_key" {
  description = "Either a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Used to encrypt password and access key. `pgp_key` is required when `create_iam_user_login_profile` is set to `true`"
  type        = string
  default     = ""
}

variable "create-new-policy" {
  type      = bool
  default   = false
  description = "If value true will create new policy"
}
variable "policy-resource" {
  description = "IAM policy resource"
  type        = string
  default     = "*"
}

variable "policy-action" {
  type      = list(string)
  default   = [
              "s3:PutObject"
               ]
  description = "IAM user name"
}
variable "policy-name" {
  type      = string
  default   = "policy-name"
  description = "Policy Name"
} 
