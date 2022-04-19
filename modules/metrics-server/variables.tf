variable "name" {
  type        = string
  default     = "metrics-server"
  description = "Metrics server name."
}

variable "cluster_host" {
  type = string
}

variable "cluster_certificate" {
  type = string
}

variable "cluster_token" {
  type = string
}

variable "cluster_name" {
  type = string
}
