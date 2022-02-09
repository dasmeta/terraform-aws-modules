variable "zone" {
  type        = string
  description = "Route53 zone name"
}

variable "create_zone" {
  type        = bool
  default     = true
  description = "controlls whether create Route53 zone or use already created zone for just generating new records"
}

variable "records" {
  type = list(object({
    name  = string,
    type  = string,
    value = set(string)
  }))
  description = "dns records name, type and value list"
  default     = []
}

variable "ttl" {
  type        = string
  default     = "30"
  description = "TTL Time"
}
