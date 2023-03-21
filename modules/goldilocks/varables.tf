variable "namespaces" {
  type        = set(string)
  default     = ["default"]
  description = "Goldilocks labels on your namespaces"
}

variable "create_metric_server" {
  type        = bool
  default     = true
  description = "Create metric server"
}

variable "create_vpa_server" {
  type        = bool
  default     = true
  description = "VPA configure in the cluster"
}

variable "zone_name" {
  type        = string
  description = "Domain Name"
  default     = null
}

variable "alb_certificate_arn" {
  type        = string
  default     = ""
  description = "Domain Certificate ARN"
}

variable "alb_name" {
  type    = string
  default = "goldilocks-dashboard"
}

variable "hostname" {
  type    = string
  default = "goldilocks.example.com"
}

variable "auth" {
  type = object({
    userPoolARN      = string,
    userPoolClientID = string,
    userPoolDomain   = string
  })
  default = {
    userPoolARN      = ""
    userPoolClientID = ""
    userPoolDomain   = ""
  }
}

variable "alb_subnet" {
  type        = string
  default     = ""
  description = "Ingress Annotations Add  EKS Public Subnet"
}

variable "create_dashboard_ingress" {
  type        = bool
  default     = true
  description = "Access Goldilocks Dashboard"
}
