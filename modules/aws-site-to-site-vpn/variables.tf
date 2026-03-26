variable "name" {
  type        = string
  description = "Name prefix for VPN Gateway, Customer Gateway, and VPN Connection resources."
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC to attach the VPN Gateway to."
}

variable "customer_gateway" {
  type = object({
    ip_address  = string
    bgp_asn     = optional(string, "65000")
    type        = optional(string, "ipsec.1")
    device_name = optional(string, null)
  })
  description = "On-premise VPN device: public IP, BGP ASN, and optional device name."
}

variable "static_routes_only" {
  type        = bool
  default     = false
  description = "Set to true if the on-premise device does not support BGP. When true, provide static_routes."
}

variable "static_routes" {
  type        = list(string)
  default     = []
  description = "List of destination CIDR blocks for static routing (e.g. on-premise networks). Used when static_routes_only is true."
}

variable "route_table_ids" {
  type        = list(string)
  default     = []
  description = "Route table IDs where routes to the VPN (destination_cidr_blocks) will be added. Leave empty to manage routes elsewhere."
}

variable "destination_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "CIDR blocks to route through the VPN (typically on-premise networks). Used with route_table_ids to create routes."
}

variable "tunnel_options" {
  type = object({
    tunnel1_preshared_key                = optional(string, null)
    tunnel2_preshared_key                = optional(string, null)
    tunnel1_inside_cidr                  = optional(string, null)
    tunnel2_inside_cidr                  = optional(string, null)
    tunnel1_ike_versions                 = optional(list(string), null)
    tunnel2_ike_versions                 = optional(list(string), null)
    tunnel1_phase1_dh_group_numbers      = optional(list(number), null)
    tunnel2_phase1_dh_group_numbers      = optional(list(number), null)
    tunnel1_phase2_encryption_algorithms = optional(list(string), null)
    tunnel2_phase2_encryption_algorithms = optional(list(string), null)
    tunnel1_phase2_integrity_algorithms  = optional(list(string), null)
    tunnel2_phase2_integrity_algorithms  = optional(list(string), null)
    tunnel1_phase1_encryption_algorithms = optional(list(string), null)
    tunnel1_phase1_integrity_algorithms  = optional(list(string), null)
    tunnel1_phase2_dh_group_numbers      = optional(list(string), null)
    tunnel1_rekey_margin_time_seconds    = optional(number, null)
    tunnel2_phase1_encryption_algorithms = optional(list(string), null)
    tunnel2_phase1_integrity_algorithms  = optional(list(string), null)
    tunnel2_phase2_dh_group_numbers      = optional(list(string), null)
    tunnel2_rekey_margin_time_seconds    = optional(number, null)
  })
  default     = {}
  description = "Tunnel options: pre-shared keys, inside CIDRs (/30), and optional IKE/phase algorithms."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to VPN Gateway, Customer Gateway, and VPN Connection."
}

variable "create_vpn_gateway" {
  type        = bool
  default     = true
  description = "Set to false to use an existing VPN Gateway (pass vpn_gateway_id via vpn_gateway_id)."
}

variable "vpn_gateway_id" {
  type        = string
  default     = null
  description = "Existing VPN Gateway ID. Used when create_vpn_gateway is false; must be attached to vpc_id elsewhere."
}

variable "vpn_gateway_amazon_side_asn" {
  type        = string
  default     = "64512"
  description = "Amazon side BGP ASN for the VPN Gateway. Used only when create_vpn_gateway is true."
}
