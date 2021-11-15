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

variable client_id {
  type        = string
  description = "The client ID for the Amazon Cognito Identity User Pool."
}

variable provider_name {
  type        = string
  description = "The provider name for an Amazon Cognito Identity User Pool."
}
variable "server_side_token_check" {
  type        = bool
  description = "Whether server-side token validation is enabled for the identity provider’s token or not."
}

variable "unauthenticated_role" {
  type        = string
  default     = "Unauthenticated_role"
  description = "Name of the unauthenticated role."
}

variable "authenticated_role" {
  type        = string
  default     = "Authenticated_role"
  description = "Name of the authenticated role."
}

variable "auth_inline_policy" {}

variable "unauth_inline_policy" {}
