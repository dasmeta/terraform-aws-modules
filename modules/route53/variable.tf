variable "zone" {
  type        = string
  description = "Zone name will create Route53"
}
variable "type_record" {
    type  = list(object({ recordid = string, recordname = string, recordtype = string, recordvalue = set(string) }))
    description = "Added record type and record"
    default = []
}

variable "ttl" {
  type        = string
  default = "30"
  description = "TTL Time"
}