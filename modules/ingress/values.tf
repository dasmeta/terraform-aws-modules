variable "alb_name" {
  type        = string
  description = "Ingress name"
}

variable "hostname" {
  type        = string
  description = "Hostname"
  default     = "test.timify.io"
}

variable "annotations" {
  type    = any
  default = {}
}

variable "path" {
  type = any
  default = [
    {
      service_name = "nginx"
      service_port = "80"
      path         = "/alb-terraform-created"
    }
  ]
}

