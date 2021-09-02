###################
## VPC Varibables##
###################
variable "vpc_name" {
  type = string
  description = "VPC name."
}

variable "cidr" {
  type = string
  # default = "172.16.0.0/16"
  description = "CIDR ip range."
}

variable "availability_zones" {
  type = list(string)
  description = "List of VPC availability zones, e.g. ['eu-west-1a', 'eu-west-1b', 'eu-west-1c']."
}

variable "private_subnets" {
  type = list(string)
  # default = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  description = "Private subnets of VPC."
}

variable "public_subnets" {
  type = list(string)
  # default = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  description = "Public subnets of VPC."
}

variable "enable_nat_gateway" {
  type = bool
  default = true
  description = "Whether or not to enable NAT Gateway."
}

variable "single_nat_gateway" {
  type = bool
  default = true
  description = "Whether or not to enable single NAT Gateway."
}

variable "enable_dns_hostnames" {
  type = bool
  default = true
  description = "Whether or not to enable dns hostnames."
}

variable "enable_dns_support" {
  type = bool
  default = true
  description = "Whether or not to enable dns support."
}

variable "public_subnet_tags" {
  type = map
  default = {}
}

variable "private_subnet_tags" {
  type = map
  default = {}
}

##################################
## AWS VPC VPN Endpoint varibles##
##################################
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "saml_provider_arn" {
  description = "The ARN of the IAM SAML identity provider."
  type        = string
}

variable "certificate_arn" {
  description = "Certificate arn"
  type        = string
}

variable "endpoint_client_cidr_block" {
  description = "The IPv4 address range, in CIDR notation, from which to assign client IP addresses. The address range cannot overlap with the local CIDR of the VPC in which the associated subnet is located, or the routes that you add manually. The address range cannot be changed after the Client VPN endpoint has been created. The CIDR block should be /22 or greater."
  type        = string
  default     = "10.100.100.0/22"
}

variable "endpoint_name" {
  description = "Name to be used on the Client VPN Endpoint"
  type        = string
}

variable "endpoint_subnets" {
  description = "List of IDs of endpoint subnets for network association"
  type        = list(string)
}

variable "authorization_ingress" {
  description = "Add authorization rules to grant clients access to the networks."
  type = list(string)
}
variable "additional_routes" {
  description = "A map where the key is a subnet ID of endpoint subnet for network association and value is a cidr to where traffic should be routed from that subnet. Useful in cases if you need to route beyond the VPC subnet, for instance peered VPC"
  type        = map(string)
  default     = {}
}

variable "endpoint_vpc_id" {
  description = "VPC where the VPN will be connected."
  type        = string
}

variable "cloudwatch_log_group_name_prefix" {
  description = "Specifies the name prefix of CloudWatch Log Group for VPC flow logs."
  type        = string
  default     = "/aws/client-vpn-endpoint/"
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group for VPN connection logs."
  type        = number
  default     = 30
}

variable "tls_validity_period_hours" {
  description = "Specifies the number of hours after initial issuing that the certificate will become invalid."
  type        = number
  default     = 47400
}
variable "peering_vps_ids" {
  description = "AWS VPCs ID "
  type = list(string)
}
