variable region {
  type        = string
  default     = "eu-east-1"
  description = "Region secrets will be pulled from."
}

variable aws_access_key {
  type        = string
  description = "The key store will be using to pull secrets from AWS Secret Manager."
}

variable aws_access_secret {
  type        = string
  description = "The secret store will be using to pull secrets from AWS Secret Manager."
}
