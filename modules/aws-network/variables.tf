variable "create_vpc" {
  type        = bool
  default     = true
  description = "Whether or not to create a VPC."
}

variable "vpc_name" {
  type        = string
  description = "VPC name."
}

variable "cidr" {
  type = string
  # default = "172.254.0.0/16"
  description = "CIDR ip range."
}

variable "availability_zones" {
  type        = list(string)
  description = "List of VPC availability zones, e.g. ['eu-west-1a', 'eu-west-1b', 'eu-west-1c']."
}

variable "private_subnets" {
  type = list(string)
  # default = ["172.254.1.0/24", "172.254.2.0/24", "172.254.3.0/24"]
  description = "Private subnets of VPC."
}

variable "public_subnets" {
  type = list(string)
  # default = ["172.254.4.0/24", "172.254.5.0/24", "172.254.6.0/24"]
  description = "Public subnets of VPC."
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Whether or not to enable NAT Gateway."
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "Whether or not to enable single NAT Gateway."
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Whether or not to enable dns hostnames."
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Whether or not to enable dns support."
}

variable "public_subnet_tags" {
  type    = map(any)
  default = {}
}

variable "private_subnet_tags" {
  type    = map(any)
  default = {}
}


##################
## VPC Peering ###
##################

variable "create_vpc_peering" {
  type        = bool
  default     = false
  description = "Whether or not to create a VPC Peering."
}
variable "main_vpc_id" {
  type        = string
  description = "CIDR ip range."
}

variable "peering_vpc_id" {
  type        = string
  description = "CIDR ip range."
}
variable "peering_tags" {
  description = "Tags: map"
  type        = map(string)
  default     = {}
}
variable "peering_region" {
  type        = string
  description = "CIDR ip range."
  default     = "eu-central-1"
}
####################
### VPN Endpoint ###
####################
variable "enable_saml" {
  type        = bool
  default     = false
  description = "Whether or not to enable SAML Provider."
}
variable "endpoint_name" {
  type        = string
  description = "VPN endpoint name"
}
variable "vpc_id" {
  type        = string
  description = "CIDR ip range."
}
variable "endpoint_client_cidr_block" {
  description = "The IPv4 address range, in CIDR notation, from which to assign client IP addresses. The address range cannot overlap with the local CIDR of the VPC in which the associated subnet is located, or the routes that you add manually. The address range cannot be changed after the Client VPN endpoint has been created. The CIDR block should be /22 or greater."
  type        = string
  default     = "10.100.100.0/22"

}
variable "saml_provider_arn" {
  description = "The ARN of the IAM SAML identity provider."
  type        = string
}
variable "certificate_arn" {
  description = "Certificate arn"
  type        = string
}
variable "authorization_ingress" {
  description = "Add authorization rules to grant clients access to the networks."
  type        = list(string)
}
variable "endpoint_subnets" {
  description = "List of IDs of endpoint subnets for network association"
  type        = list(string)
  #default = ["subnet-0803b8f53842cb628","subnet-0f9a1ebddcea11a5c","subnet-08c91e06b4546c5ca"]
}
