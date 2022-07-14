variable "api_id" {
  type        = string
  description = "The API Gateway id"
}

variable "stage_name" {
  type        = string
  description = "The API Gateway stage name"
}

variable "custom_domain" {
  type = object({
    name      = string # this is just first part of domain without zone part
    zone_name = string
  })
  default = {
    name      = ""
    zone_name = ""
  }
  description = "Allows to setup/attach custom domain to api gateway setup, it will create also r53 record and certificate. Note that all keys of object are required to pass when you need one"
}

variable "endpoint_config_type" {
  type        = string
  default     = "REGIONAL"
  description = "API Gateway config type. Valid values: EDGE, REGIONAL or PRIVATE"
}
