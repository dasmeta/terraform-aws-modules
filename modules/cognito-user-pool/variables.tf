variable "name" {
  type        = string
  default     = "Pool name"
  description = "Name of the pool that will be created"
}

variable "clients" {
  type        = list(string)
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
  default = false
}

variable "device_only_remembered_on_user_prompt" {
  default = true
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

variable "software_token_mfa_configuration_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable software token Multi-Factor (MFA) tokens, such as Time-based One-Time Password (TOTP)."
}

variable "username_case_sensitive" {
  type        = bool
  default     = false
  description = "Whether username case sensitivity will be applied for all users in the user pool through Cognito APIs."
}

# variable "domain" {
  
# }

# variable "cert_arn" {
  
# }

# variable "r53_zone" {
  
# }
