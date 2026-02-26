# -----------------------------------------------------------------------------
# VPN Gateway (AWS side)
# -----------------------------------------------------------------------------

resource "aws_vpn_gateway" "this" {
  count = var.create_vpn_gateway ? 1 : 0

  vpc_id            = var.vpc_id
  amazon_side_asn   = var.vpn_gateway_amazon_side_asn
  availability_zone = null

  tags = merge(var.tags, {
    Name = "${var.name}-vgw"
  })
}

resource "aws_vpn_gateway_attachment" "this" {
  count = var.create_vpn_gateway ? 1 : 0

  vpc_id         = var.vpc_id
  vpn_gateway_id = aws_vpn_gateway.this[0].id
}

locals {
  vpn_gateway_id = var.create_vpn_gateway ? aws_vpn_gateway.this[0].id : var.vpn_gateway_id
}

# -----------------------------------------------------------------------------
# Customer Gateway (on-premise side representation)
# -----------------------------------------------------------------------------

resource "aws_customer_gateway" "this" {
  bgp_asn    = var.customer_gateway.bgp_asn
  ip_address = var.customer_gateway.ip_address
  type       = var.customer_gateway.type

  device_name = var.customer_gateway.device_name

  tags = merge(var.tags, {
    Name = "${var.name}-cgw"
  })
}

# -----------------------------------------------------------------------------
# VPN Connection (site-to-site)
# -----------------------------------------------------------------------------

resource "aws_vpn_connection" "this" {
  vpn_gateway_id      = local.vpn_gateway_id
  customer_gateway_id = aws_customer_gateway.this.id
  type                = var.customer_gateway.type

  static_routes_only = var.static_routes_only

  # Tunnel options
  tunnel1_preshared_key = try(var.tunnel_options.tunnel1_preshared_key, null)
  tunnel2_preshared_key = try(var.tunnel_options.tunnel2_preshared_key, null)
  tunnel1_inside_cidr   = try(var.tunnel_options.tunnel1_inside_cidr, null)
  tunnel2_inside_cidr   = try(var.tunnel_options.tunnel2_inside_cidr, null)

  tunnel1_ike_versions                 = try(var.tunnel_options.tunnel1_ike_versions, null)
  tunnel2_ike_versions                 = try(var.tunnel_options.tunnel2_ike_versions, null)
  tunnel1_phase1_dh_group_numbers      = try(var.tunnel_options.tunnel1_phase1_dh_group_numbers, null)
  tunnel2_phase1_dh_group_numbers      = try(var.tunnel_options.tunnel2_phase1_dh_group_numbers, null)
  tunnel1_phase2_encryption_algorithms = try(var.tunnel_options.tunnel1_phase2_encryption_algorithms, null)
  tunnel2_phase2_encryption_algorithms = try(var.tunnel_options.tunnel2_phase2_encryption_algorithms, null)
  tunnel1_phase2_integrity_algorithms  = try(var.tunnel_options.tunnel1_phase2_integrity_algorithms, null)
  tunnel2_phase2_integrity_algorithms  = try(var.tunnel_options.tunnel2_phase2_integrity_algorithms, null)

  tags = merge(var.tags, {
    Name = "${var.name}-vpn"
  })
}

# -----------------------------------------------------------------------------
# Static routes (advertised to on-premise when static_routes_only = true)
# -----------------------------------------------------------------------------

resource "aws_vpn_connection_route" "this" {
  for_each = var.static_routes_only ? toset(var.static_routes) : toset([])

  destination_cidr_block = each.value
  vpn_connection_id      = aws_vpn_connection.this.id
}

# -----------------------------------------------------------------------------
# Routes in VPC route tables (send traffic to on-premise via VPN)
# -----------------------------------------------------------------------------

resource "aws_route" "vpn" {
  for_each = length(var.route_table_ids) > 0 && length(var.destination_cidr_blocks) > 0 ? {
    for pair in setproduct(var.route_table_ids, var.destination_cidr_blocks) : "${pair[0]}-${pair[1]}" => {
      route_table_id         = pair[0]
      destination_cidr_block = pair[1]
    }
  } : {}

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block
  gateway_id             = local.vpn_gateway_id
}
