resource "test_assertions" "vpn_connection" {
  component = "site-to-site-vpn"

  check "vpn_connection_id_is_set" {
    description = "VPN connection is created and has an ID"
    assert      = length(module.site_to_site_vpn.vpn_connection_id) > 0
  }

  check "tunnel_addresses_are_set" {
    description = "Both tunnel endpoints are assigned"
    assert = (
      length(module.site_to_site_vpn.vpn_connection_tunnel1_address) > 0 &&
      length(module.site_to_site_vpn.vpn_connection_tunnel2_address) > 0
    )
  }
}
