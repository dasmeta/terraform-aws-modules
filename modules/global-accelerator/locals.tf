locals {
  listeners = {
    for listener_key, listener in var.listeners : listener_key => {
      protocol        = listener.protocol
      client_affinity = listener.client_affinity
      port_ranges     = listener.port_ranges
      endpoint_groups = {
        for group_key, group in listener.endpoint_groups : group_key => merge(
          {
            endpoint_group_region         = group.endpoint_group_region
            traffic_dial_percentage       = group.traffic_dial_percentage
            health_check_protocol         = group.health_check.protocol
            health_check_interval_seconds = group.health_check.interval_seconds
            threshold_count               = group.health_check.threshold_count
            endpoint_configuration = [
              for endpoint in group.endpoints : merge(
                {
                  endpoint_id = endpoint.endpoint_id
                  weight      = endpoint.weight
                },
                endpoint.client_ip_preservation_enabled == null ? {} : {
                  client_ip_preservation_enabled = endpoint.client_ip_preservation_enabled
                }
              )
            ]
            port_override = group.port_overrides
          },
          group.health_check.port == null ? {} : {
            health_check_port = group.health_check.port
          },
          group.health_check.path == null ? {} : {
            health_check_path = group.health_check.path
          }
        )
      }
    }
  }
}
