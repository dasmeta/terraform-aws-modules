variable "name" {
  type        = string
  default     = "Pool name"
  description = "Name of the pool that will be created"
}

variable "clients" {
  type        = list(string)
  default     = []
  description = "List of client names"
}

variable "generate_secret" {
  type        = bool
  default     = false
  description = "Should an application secret be generated."
}

variable "alias_attributes" {
  type        = list(string)
  default     = [ "email", "phone_number" ]
  description = "Attributes supported as an alias for this user pool."
}

variable "auto_verified_attributes" {
  type        = list(string)
  default     = [ "email", "phone_number" ]
  description = "Attributes to be auto-verified."
}

variable "email_verification_message" {
  type        = string
  default     = "Some message {####}"
  description = "String representing the email verification message."
}

variable "email_verification_subject" {
  type        = string
  default     = "Some subject"
  description = "String representing the email verification subject."
}

variable "mfa_configuration" {
  type        = string
  default     = "OPTIONAL"
  description = "Multi-Factor Authentication (MFA) configuration for the User Pool."
}

variable "sms_authentication_message" {
  type        = string
  default     = "SMS authentication message {####}"
  description = "String representing the SMS authentication message. The Message must contain the {####} placeholder, which will be replaced with the code."
}

variable "sms_verification_message" {
  type        = string
  default     = "SMS verification message {####}"
  description = "String representing the SMS verification message."
}

variable "verification_message_template" {
  type        = map
  default     = {
    "email_message_by_link" = "Please click the link below to verify your email address. {##Verify Email##} "
    "email_subject_by_link" = "Your verification link. {##Verify Email##}"
  }
  description = "email_message_by_link is an email message template for sending a confirmation link to the user, it must contain the {##Click Here##} placeholder. email_subject_by_link is an email message template for sending a confirmation link to the user, it must contain the {##Click Here##} placeholder."
}

variable "sms_configuration" {
  type        = map
  default     = {
    external_id    = ""
    sns_caller_arn = ""
  }
  description = "external_id is external ID used in IAM role trust relationships. sns_caller_arn is ARN of the Amazon SNS caller."  
}

variable "recovery_mechanism" {
  default     = [
    {
      "name"     = "verified_email"
      "priority" = 2
    },
    {
      "name"     = "verified_phone_number"
      "priority" = 1
    }
  ]
  description = "Name is the recovery method for a user. Priority is a positive integer specifying priority of a method with 1 being the highest priority."
}

variable "invite_message_template" {
  default     = {
    email_message = "Your username is {username} and temporary password is {####}. "
    email_subject = "Your temporary password"
    sms_message   = "Your username is {username} and temporary password is {####}. "
  }
  description = "email_message is a message template for email messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively. email_subject is a subject line for email messages. sms_message is a message template for SMS messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively."
}

variable "challenge_required_on_new_device" {
  type        = bool
  default     = null
  description = "Whether a challenge is required on a new device. Only applicable to a new device."
}

variable "device_only_remembered_on_user_prompt" {
  type        = bool
  default     = null
  description = "Whether a device is only remembered on user prompt."
}

variable "lambda_config" {
  default = {
    kms_key_id = ""

    custom_email_sender = {
        lambda_arn = ""
        lambda_version = ""
    }
  }
}

variable "schema" {
  default     = [
    {
      "attribute_data_type"      = "String"
      "developer_only_attribute" = false
      "mutable"                  = true
      "name"                     = "email"
      "required"                 = true
      string_attribute_constraints = {
        max_length = ""
        min_length = ""
      }
    },
  ]
}

variable "software_token_mfa_configuration" {
  type        = bool
  default     = true
  description = "Whether to enable software token Multi-Factor (MFA) tokens, such as Time-based One-Time Password (TOTP)."
}

variable "case_sensitive" {
  type        = bool
  default     = null
  description = "Whether username case sensitivity will be applied for all users in the user pool through Cognito APIs."
}

variable "user_group" {
  type        = string
  default     = ""
  description = "The name of the user group."
}

variable "precedence" {
  type        = number
  default     = 0
  description = "The precedence of the user group."
}

variable "role_arn" {
  type        = string
  default     = ""
  description = "The ARN of the IAM role to be associated with the user group."
}

variable "domain" {
  type        = string
  default     = ""
  description = "The domain string."
}

variable "cert_arn" {
  type        = string
  default     = ""
  description = "The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain."
}

variable "zone_id" {
  type        = string
  default     = ""
  description = "R53 zone."
}

variable "access_token_validity" {
  type        = number
  default     = 120
  description = "Time limit, between 5 minutes and 1 day, after which the access token is no longer valid and cannot be used. This value will be overridden if you have entered a value in token_validity_units."
}

variable "allowed_oauth_flows_user_pool_client" {
  type        = bool
  default     = false
  description = "Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools."
}

variable "enable_token_revocation" {
  type        = bool
  default     = true
  description = "Enables or disables token revocation."
}

variable "explicit_auth_flows" {
  type        = list(string)
  default     = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]
  description = "List of authentication flows."
}

variable "id_token_validity" {
  type        = number
  default     = 120
  description = "Time limit, between 5 minutes and 1 day, after which the ID token is no longer valid and cannot be used. This value will be overridden if you have entered a value in token_validity_units."
}

variable "prevent_user_existence_errors" {
  type        = string
  default     = "LEGACY"
  description = "Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool."
}

variable "read_attributes" {
  type        = list(string)
  default     = [
    "address",
    "birthdate",
    "email",
    "email_verified",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "phone_number_verified",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]
  description = "List of user pool attributes the application client can read from."
}

variable "refresh_token_validity" {
  type        = number
  default     = 7
  description = "Time limit in days refresh tokens are valid for."
}

variable "write_attributes" {
  type        = list(string)
  default     = [
    "address",
    "birthdate",
    "email",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]
  description = "List of user pool attributes the application client can write to."
}

variable "token_validity_units" {
  type        = map
  default     = {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
  description = "access_token is time unit in for the value in access_token_validity. id_token is time unit in for the value in id_token_validity. refresh_token is time unit in for the value in refresh_token_validity."
}

variable "callback_urls" {
  type        = list(string)
  default     = []
  description = "List of allowed callback URLs for the identity providers."
}

variable "logout_urls" {
  type        = list(string)
  default     = []
  description = "List of allowed logout URLs for the identity providers."
}

variable "allowed_oauth_flows" {
  type        = list(string)
  default     = []
  description = "List of allowed OAuth flows (code, implicit, client_credentials)."
}

variable "allowed_oauth_scopes" {
  type        = list(string)
  default     = []
  description = "List of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito.signin.user.admin)."
}

variable "supported_identity_providers" {
  type        = list(string)
  default     = []
  description = "List of provider names for the identity providers that are supported on this client."
}
