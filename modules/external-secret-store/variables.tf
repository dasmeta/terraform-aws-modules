variable name {
  type        = string
  description = "Secret store name"
}

variable controller {
  type        = string
  description = "Not sure what it is yet"
}

variable region {
  type        = string
  default     = "eu-east-1"
  description = "Region secrets will be pulled from."
}

variable aws_account_id {
  type        = string
  description = "AWS Account ID to read secrets from. Used to inject policy."
}

variable aws_access_key {
  type        = string
  description = "The key store will be using to pull secrets from AWS Secret Manager."
}

variable aws_access_secret {
  type        = string
  description = "The secret store will be using to pull secrets from AWS Secret Manager."
}
