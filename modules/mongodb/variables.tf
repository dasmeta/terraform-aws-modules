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

variable "name" {
  type        = string
  default     = "mongodb"
  description = "Release name."
}

variable "values" {
  description = "Extra values"
  type        = list(string)
  default     = null
}

variable "set" {
  description = "Value block with custom STRING values to be merged with the values yaml."
  type = list(object({
    name  = string
    value = string
  }))
  default = null
}

variable "chart_version" {
  type    = string
  default = "10.8.0"
}
