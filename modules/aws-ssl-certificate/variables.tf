variable "domain" {
  type        = string
  description = "Domain name ssl certificate will be created for."
}

variable "alternative_domains" {
  type       = list(string)
  escription = "Subdomain or Wildcard name ssl certificate will be created."
}
variable "zone" {
  type        = string
  description = "This variable use route53.Can equal to domain name"
}

variable "tags" {
  type = object({ key = string, value = string })
  default = {
    key   = "Environment"
    value = "prod"
  }
}
