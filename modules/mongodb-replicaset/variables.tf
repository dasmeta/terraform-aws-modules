variable "setup" {
  type        = string
  default     = "standalone"
  description = "Which mongodb setup to consider: standalone (default), replicaset."
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
