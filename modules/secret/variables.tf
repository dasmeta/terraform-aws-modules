variable "name" {
  type        = string
  description = "Secret name"
}

variable "value" {
  type        = any
  default     = null
  description = "Secret value"
}
