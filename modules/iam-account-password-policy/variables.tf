
variable "allow_users_to_change_password" {
  default     = false
  type        = bool
  description = "Whether to allow users to change their own password."
}

variable "minimum_password_length" {
  default     = 14
  type        = number
  description = "Minimum length to require for user passwords."
}

variable "require_lowercase_characters" {
  default     = true
  type        = bool
  description = "Whether to require lowercase characters for user passwords."
}

variable "require_numbers" {
  default     = true
  type        = bool
  description = "Whether to require numbers for user passwords."
}

variable "require_symbols" {
  default     = true
  type        = bool
  description = "Whether to require symbols for user passwords."
}

variable "require_uppercase_characters" {
  default     = true
  type        = bool
  description = "Whether to require uppercase characters for user passwords."
}

variable "max_password_age" {
  default     = 90
  type        = number
  description = "The number of days that an user password is valid. If specify 0, then passwords never expire."
}

variable "hard_expiry" {
  default     = true
  type        = bool
  description = "Whether users are prevented from setting a new password after their password has expired."
}

variable "password_reuse_prevention" {
  default     = 0
  type        = number
  description = "The number of previous passwords that users are prevented from reusing. If specify 0, then allowed from reusing previous passwords."
}
