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
  default     = ""
}

variable "certificate_arn" {
  description = "Certificate arn"
  type        = string
}

variable "client_certificate_arn" {
  description = "Client Certificate arn when we setup certificate-authentication type vpn"
  type        = string
  default     = ""
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

variable "authorization_ingress" {
  description = "Add authorization rules to grant clients access to the networks."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "additional_routes" {
  description = "A map where the key is a subnet ID of endpoint subnet for network association and value is a cidr to where traffic should be routed from that subnet. Useful in cases if you need to route beyond the VPC subnet, for instance peered VPC"
  type        = any
  default     = {}
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

variable "cloudwatch_log_group_kms_key_id" {
  description = "Specifies the ARN of the CMK to use when encrypting log data."
  type        = string
  default     = null
}


variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "endpoint_subnets" {
  description = "List of IDs of endpoint subnets for network association"
  type        = list(string)
}

variable "peering_vpc_ids" {
  type    = list(string)
  default = []
}

variable "split_tunnel" {
  type    = bool
  default = true
}

variable "vpn_port" {
  type    = number
  default = 443
}

variable "dns_servers" {
  type        = list(string)
  description = "Ip address DNS servers to be used for DNS resolution"
  default     = []
}

variable "security_group_rule" {
  type        = any
  description = "Security group inbound and outbound rules"
  default = {
    ingress = {
      1 = {
        description = "Ingress access"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
    egress = {
      1 = {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        description = "Egress access"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  }
}

variable "disconnect_on_session_timeout" {
  type        = bool
  default     = true
  description = "Indicates whether the client VPN session is disconnected after the maximum session_timeout_hours is reached. If true, users are prompted to reconnect client VPN. If false, client VPN attempts to reconnect automatically."
}

variable "session_timeout_hours -" {
  type        = number
  description = "The maximum session duration is a trigger by which end-users are required to re-authenticate prior to establishing a VPN session. Default value is 24 - Valid values: 8 | 10 | 12 | 24"
  default     = 24
}
