variable "identity_pool_name" {
  type        = string
  default     = ""
  description = "The Cognito Identity Pool name."
}

variable "allow_classic_flow" {
  type        = bool
  default     = true
  description = "Enables or disables the classic / basic authentication flow."
}

variable "allow_unauthenticated_identities" {
  type        = bool
  default     = false
  description = "Whether the identity pool supports unauthenticated logins or not."
}

variable "roles" {
  type        = map
  default     = {
    "authenticated"   = ""
    "unauthenticated" = ""
  }
  description = "The map of roles associated with the identity pool. Each value will be the Role ARN."
}

variable "role_mapping" {
  type        = map
  default     = {
    "ambiguous_role_resolution" = ""
    "identity_provider"         = ""
    "type"                      = ""
  }
  description = "ambiguous_role_resolution specifies the action to be taken if either no rules match the claim value for the Rules type, or there is no cognito:preferred_role claim and there are multiple cognito:roles matches for the Token type. type is the role mapping type. "
}

variable "cognito_identity_providers" {
  default     = [
    {
      "client_id"     = null
      "provider_name" = null
    },
  ]
  description = "An array of Amazon Cognito Identity user pools and their client IDs."
}

variable "supported_login_providers" {
  type        = map 
  default     = {
      "accounts.google.com" = null
      "graph.facebook.com"  = null
      "www.amazon.com"      = null
      "api.twitter.com"     = null
      "www.digits.com"      = null
  }
  description = "Key-Value pairs mapping provider names to provider app IDs."
}
