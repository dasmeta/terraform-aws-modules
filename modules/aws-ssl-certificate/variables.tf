variable zone {
  type        = string
  description = "Zone ssl certificate will be created in (e.g. mydomain.com). Should not start or end with dot."
}

variable domain {
  type        = string
  description = "Domain name ssl certificate will be created for (e.g. auth). This will be combined with zone."
}
