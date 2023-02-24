variable "api_id" {
  type        = string
  description = "The API Gateway id"
}

variable "stage_name" {
  type        = string
  description = "The API Gateway stage name"
}

variable "custom_domains" {
  type = list(object({
    name      = string # this is just first/prefix/subdomain part of domain without zone part
    zone_name = string
  }))
  default     = []
  description = "Allows to setup/attach custom domain to api gateway setup, it will create also r53 record and certificate. Note that all keys of object are required to pass when you need one"
}

variable "custom_domain_additional_options" {
  type = list(list(object({
    set_identifier             = string
    geolocation_routing_policy = any
  })))
  default     = []
  description = "Additional route53 configs in this list for using along side to custom_domain listing"
}

variable "endpoint_config_type" {
  type        = string
  default     = "REGIONAL"
  description = "API Gateway config type. Valid values: EDGE, REGIONAL or PRIVATE"
}

variable "security_policy" {
  type        = string
  default     = "TLS_1_2"
  description = "(Optional) Transport Layer Security (TLS) version + cipher suite for this DomainName. Valid values are TLS_1_0 and TLS_1_2. Must be configured to perform drift detection."
}
