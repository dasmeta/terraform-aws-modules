variable "alb_name" {
  type        = string
  description = "Ingress name"
}

variable "hostname" {
  type        = string
  description = "Hostname"
}

variable "annotations" {
  type    = any
  default = {}
}

variable "path" {
  type = list(object({
    service_name        = string
    service_port_number = string
    service_port_name   = string
    path                = string
  }))
  default = [
    {
      service_name        = "response-200"
      service_port_number = null
      service_port_name   = "use-annotation"
      path                = "/200"
    }
  ]
}
variable "default_backend" {
  type = object({
    service_name = string
    service_port = string
  })
  default = {
    service_name = null
    service_port = null
  }
}
# TODO: check if there is way to get this data as kubernetes data
variable "api_version" {
  type        = string
  default     = "networking/v1"
  description = "The api version of ingress, can be networking/v1 and extensions/v1beta1 for now"
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "tls_hosts" {
  type        = list(string)
  default     = null
  description = "Hosts are a list of hosts included in the TLS certificate."
}
