variable name {
  type        = string
  description = "Secret store name."
}

variable controller {
  type        = string
  default     = ""
  description = "Not sure what is this for yet."
}

variable aws_access_key_id {
  type        = string
  default     = ""
  description = "The key store will be using to pull secrets from AWS Secret Manager."
}

variable aws_access_secret {
  type        = string
  default     = ""
  description = "The secret store will be using to pull secrets from AWS Secret Manager."
}

variable create_user {
  type        = bool
  default     = true
  description = "Create IAM user to read credentials or aws_access_key_id / aws_access_secret combination should be used."
}
