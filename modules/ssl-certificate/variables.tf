variable "domain" {
  type        = string
  description = "Main domain name for ssl certificate."
}

variable "alternative_domains" {
  type        = list(string)
  description = "Subdomain or other domain or wildcard for the certificate."
  default     = []
}

variable "zone" {
  type        = string
  description = "R53 zone name where the certificate can be validated. Can be the same like domain"
  default     = ""
}

variable "alternative_zones" {
  type        = list(string)
  description = "This variable uses route53. Must equal to alternative_domains. (Note. When you use wildcard must be equal to main zone)"
  default     = [""]
}

variable "tags" {
  type        = any
  description = "tags"
  default     = {}
}

variable "validate" {
  type        = bool
  description = "Whether validate the certificate in R53 zone or not."
  default     = true
}
