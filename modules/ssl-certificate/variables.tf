variable "domain" {
  type        = string
  description = "Main domain name ssl certificate."
}

variable "alternative_domains" {
  type        = list(string)
  description = "Subdomain or other domain or wildcard certificate name will be create."
  default     = []
}

variable "zone" {
  type        = string
  description = "This variable use route53. Can equal to main domain name."
}

variable "alternative_zones" {
  type        = list(string)
  description = "This variable use route53. Must equal to alternative_domains. (Note. When you use wildcard must be equal to main zone)"
  default     = []
}

variable "tags" {
  type        = any
  description = "tags"
  default     = {}
}
