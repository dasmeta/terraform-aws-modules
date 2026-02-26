# Example: site-to-site VPN between AWS VPC and on-premise
# Replace customer_gateway.ip_address with your on-premise VPN device public IP.

module "site_to_site_vpn" {
  source = "../.."

  name   = "onprem-vpn"
  vpc_id = aws_vpc.main.id

  customer_gateway = {
    ip_address  = "203.0.113.10" # Replace with on-premise VPN device public IP
    bgp_asn     = "65000"
    type        = "ipsec.1"
    device_name = "onprem-fortigate"
  }

  # Use static routes if on-premise device does not support BGP
  static_routes_only = true
  static_routes      = ["10.0.0.0/16"] # VPC CIDR advertised to on-premise

  # Route traffic to on-premise networks via VPN
  route_table_ids         = [aws_route_table.main.id]
  destination_cidr_blocks = ["192.168.0.0/16"] # On-premise CIDR(s)

  # Optional: pre-shared keys and inside CIDRs (must match on-premise config)
  tunnel_options = {
    tunnel1_preshared_key = ""
    tunnel2_preshared_key = ""
    tunnel1_inside_cidr   = "169.254.21.0/30"
    tunnel2_inside_cidr   = "169.254.22.0/30"
  }

  tags = {
    Environment = "test"
  }
}
