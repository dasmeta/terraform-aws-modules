variable "region" {
  type        = string
  description = "The region where ressources should be managed."
  default     = null
}

variable "email_domain" {
  type        = string
  description = "For which sender domain SES should be configured."
}

variable "mail_users" {
  type        = list(string)
  description = "User names for mail to create."
}

variable "create_dkim_route53" {
  type        = bool
  description = "If DKIM records should be created in Route 53"
  default     = false
}

variable "create_spf_route53" {
  type        = bool
  description = "If TXT record for SPF should be created in Route 53"
  default     = false
}

variable "verified_email_users" {
  type        = list(string)
  default     = []
  description = "The emails address to assign to SES."
}

variable "verified_domains" {
  type        = list(string)
  default     = []
  description = "The domain name to assign to SES."
}
