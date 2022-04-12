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

variable "userpoolarn" {
  type    = string
  default = "Goldilock use Cognito User pool for Auth. Set Cognito UserPool ARN"
}
variable "userpoolclientid" {
  type    = string
  default = "Goldilock use Cognito User pool for Auth. Set Cognito UserPool Client ID"
}
variable "userpooldomain" {
  type        = string
  default     = ""
  description = "Goldilock use Cognito User pool for Auth. Set Cognito UserPool Domain name"
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
