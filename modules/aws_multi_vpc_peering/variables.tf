variable "main_vpc" {
  description = "MainVPC Id"
  type        = string
}

variable "peering_vpc_id" {
  description = "Peering VPC ids."
  type        = list(string)
}

variable "region" {
  description = "Regioin"
  type        = string
}
