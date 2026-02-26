output "vpn_connection_id" {
  description = "ID of the VPN connection."
  value       = aws_vpn_connection.this.id
}

output "vpn_connection_arn" {
  description = "ARN of the VPN connection."
  value       = aws_vpn_connection.this.arn
}

output "vpn_connection_tunnel1_address" {
  description = "Public IP address of the first VPN tunnel (AWS side). Configure this on the on-premise VPN device as the remote endpoint."
  value       = aws_vpn_connection.this.tunnel1_address
}

output "vpn_connection_tunnel2_address" {
  description = "Public IP address of the second VPN tunnel (AWS side). Configure this on the on-premise VPN device as the second tunnel endpoint."
  value       = aws_vpn_connection.this.tunnel2_address
}

output "vpn_connection_customer_gateway_configuration" {
  description = "XML configuration for the on-premise VPN device. Use this to configure the device or derive tunnel endpoints and inside CIDRs."
  value       = aws_vpn_connection.this.customer_gateway_configuration
  sensitive   = true
}

output "vpn_gateway_id" {
  description = "ID of the VPN Gateway (created or passed in)."
  value       = local.vpn_gateway_id
}

output "vpn_gateway_arn" {
  description = "ARN of the VPN Gateway. Null if using an existing gateway."
  value       = var.create_vpn_gateway ? aws_vpn_gateway.this[0].arn : null
}

output "customer_gateway_id" {
  description = "ID of the Customer Gateway (on-premise representation)."
  value       = aws_customer_gateway.this.id
}

output "vpn_connection_static_routes_supported" {
  description = "Whether the VPN connection supports static routes (true when static_routes_only is true)."
  value       = aws_vpn_connection.this.static_routes_only
}
