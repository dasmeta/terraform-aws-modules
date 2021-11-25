variable "zone" {
  type        = string
  description = "Zone name will create Route53"
}
variable "records" {
    type    = list(object({
      id    = string, 
      name  = string,
      type  = string,
      value = set(string) 
    }))
    description = "Added record id,name,type and value. Id must be unique."
    default     = []
}

variable "ttl" {
  type        = string
  default     = "30"
  description = "TTL Time"
}
