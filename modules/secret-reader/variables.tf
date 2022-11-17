variable "name" {
  type        = string
  description = "Your secret name"
}

variable "secret_key" {
  type        = string
  default     = null
  description = "You can get secret value if set key name"
}
