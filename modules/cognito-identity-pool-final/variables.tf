variable "identity_pool_name" {
  type        = string
  default     = "my-identity-pool"
  description = "The Cognito Identity Pool name."
}

variable "allow_unauthenticated_identities" {
  type        = bool
  default     = false
  description = "Whether the identity pool supports unauthenticated logins or not."
}

variable "allow_classic_flow" {
  type        = bool
  default     = false
  description = "Enables or disables the classic / basic authentication flow."
}

variable "user_pool_name" {
  type        = string
  default     = "my-user-pool"
  description = "Name of the user pool that will be created."
}

variable "user_pool_client" {
  type        = string
  default     = "user1"
  description = "A user pool client name."
}
