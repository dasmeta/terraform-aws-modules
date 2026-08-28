mock_provider "aws" {
  override_during = plan

  mock_resource "aws_globalaccelerator_accelerator" {
    defaults = {
      arn                 = "arn:aws:globalaccelerator::123456789012:accelerator/mock"
      dns_name            = "mock.awsglobalaccelerator.com"
      dual_stack_dns_name = "mock.dualstack.awsglobalaccelerator.com"
      hosted_zone_id      = "Z2BJ6XQ5FK7U4H"
      ip_sets = [{
        ip_addresses = ["192.0.2.10", "192.0.2.11"]
        ip_family    = "IPv4"
      }]
    }
  }

  mock_resource "aws_globalaccelerator_listener" {
    defaults = {
      arn = "arn:aws:globalaccelerator::123456789012:accelerator/mock/listener/mock"
    }
  }

  mock_resource "aws_globalaccelerator_endpoint_group" {
    defaults = {
      arn = "arn:aws:globalaccelerator::123456789012:accelerator/mock/listener/mock/endpoint-group/mock"
    }
  }
}

variables {
  name = "example-global-accelerator"

  listeners = {
    web_api = {
      port_ranges = [{
        from_port = 443
        to_port   = 443
      }]

      endpoint_groups = {
        eu_primary = {
          endpoint_group_region = "eu-central-1"
          health_check = {
            protocol         = "HTTPS"
            port             = 443
            path             = "/health"
            interval_seconds = 10
            threshold_count  = 5
          }
          traffic_dial_percentage = 75
          endpoints = [{
            endpoint_id                    = "arn:aws:elasticloadbalancing:eu-central-1:123456789012:loadbalancer/app/example/0123456789abcdef"
            weight                         = 200
            client_ip_preservation_enabled = true
          }]
          port_overrides = [{
            listener_port = 443
            endpoint_port = 8443
          }]
        }

        us-secondary = {
          endpoint_group_region = "us-east-1"
          endpoints = [{
            endpoint_id = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/net/example/0123456789abcdef"
          }]
          port_overrides = [{
            listener_port = 443
            endpoint_port = 8443
          }]
        }
      }
    }

    dns-edge = {
      protocol = "UDP"
      port_ranges = [{
        from_port = 53
        to_port   = 53
      }]

      endpoint_groups = {
        edge_primary = {
          endpoint_group_region = "eu-west-1"
          endpoints = [{
            endpoint_id = "eipalloc-0123456789abcdef0"
          }]
        }
      }
    }
  }
}

run "normalizes_standard_accelerator" {
  command = plan

  override_resource {
    target = module.this.aws_globalaccelerator_accelerator.this[0]
    values = {
      arn                 = "arn:aws:globalaccelerator::123456789012:accelerator/example"
      dns_name            = "a1234567890example.awsglobalaccelerator.com"
      dual_stack_dns_name = "a1234567890example.dualstack.awsglobalaccelerator.com"
      hosted_zone_id      = "Z2BJ6XQ5FK7U4H"
      ip_sets = [{
        ip_addresses = ["192.0.2.10", "192.0.2.11"]
        ip_family    = "IPv4"
      }]
    }
  }

  override_resource {
    target = module.this.aws_globalaccelerator_listener.this["web_api"]
    values = {
      arn = "arn:aws:globalaccelerator::123456789012:accelerator/example/listener/web-api"
    }
  }

  override_resource {
    target = module.this.aws_globalaccelerator_listener.this["dns-edge"]
    values = {
      arn = "arn:aws:globalaccelerator::123456789012:accelerator/example/listener/dns-edge"
    }
  }

  override_resource {
    target = module.this.aws_globalaccelerator_endpoint_group.this["web_api:eu_primary"]
    values = {
      arn = "arn:aws:globalaccelerator::123456789012:accelerator/example/listener/web-api/endpoint-group/eu-primary"
    }
  }

  override_resource {
    target = module.this.aws_globalaccelerator_endpoint_group.this["web_api:us-secondary"]
    values = {
      arn = "arn:aws:globalaccelerator::123456789012:accelerator/example/listener/web-api/endpoint-group/us-secondary"
    }
  }

  override_resource {
    target = module.this.aws_globalaccelerator_endpoint_group.this["dns-edge:edge_primary"]
    values = {
      arn = "arn:aws:globalaccelerator::123456789012:accelerator/example/listener/dns-edge/endpoint-group/edge-primary"
    }
  }

  assert {
    condition     = var.enabled && var.ip_address_type == "IPV4" && length(var.tags) == 0
    error_message = "The accelerator must default to enabled IPv4 operation with no tags."
  }

  assert {
    condition     = !var.flow_logs.enabled && var.flow_logs.s3_bucket == null && var.flow_logs.s3_prefix == null
    error_message = "Flow logs must default to disabled with null bucket and prefix values."
  }

  assert {
    condition     = module.this.listeners["web_api"].protocol == "TCP" && module.this.listeners["web_api"].client_affinity == "NONE"
    error_message = "Listener protocol and client affinity defaults must reach upstream v3."
  }

  assert {
    condition     = module.this.listeners["dns-edge"].protocol == "UDP" && one(module.this.listeners["dns-edge"].port_range).from_port == 53 && one(module.this.listeners["dns-edge"].port_range).to_port == 53
    error_message = "Explicit listener protocol and port ranges must reach upstream v3."
  }

  assert {
    condition     = toset(keys(module.this.listeners)) == toset(["web_api", "dns-edge"])
    error_message = "Upstream listener keys must retain their logical names."
  }

  assert {
    condition     = toset(keys(module.this.endpoint_groups)) == toset(["web_api:eu_primary", "web_api:us-secondary", "dns-edge:edge_primary"])
    error_message = "Endpoint groups must be flattened to collision-safe upstream composite keys."
  }

  assert {
    condition = (
      local.listeners["web_api"].endpoint_groups["eu_primary"].endpoint_group_region == "eu-central-1" &&
      local.listeners["web_api"].endpoint_groups["us-secondary"].endpoint_group_region == "us-east-1" &&
      local.listeners["dns-edge"].endpoint_groups["edge_primary"].endpoint_group_region == "eu-west-1" &&
      module.this.endpoint_groups["web_api:eu_primary"].endpoint_group_region == "eu-central-1" &&
      module.this.endpoint_groups["web_api:us-secondary"].endpoint_group_region == "us-east-1" &&
      module.this.endpoint_groups["dns-edge:edge_primary"].endpoint_group_region == "eu-west-1"
    )
    error_message = "Every endpoint-group Region must retain its exact value through upstream normalization."
  }

  assert {
    condition = (
      module.this.endpoint_groups["web_api:eu_primary"].listener_arn == module.this.listeners["web_api"].id &&
      module.this.endpoint_groups["web_api:us-secondary"].listener_arn == module.this.listeners["web_api"].id &&
      module.this.endpoint_groups["dns-edge:edge_primary"].listener_arn == module.this.listeners["dns-edge"].id
    )
    error_message = "Each flattened endpoint group must reference its parent listener logical key."
  }

  assert {
    condition = (
      module.this.endpoint_groups["web_api:eu_primary"].health_check_protocol == "HTTPS" &&
      module.this.endpoint_groups["web_api:eu_primary"].health_check_port == 443 &&
      module.this.endpoint_groups["web_api:eu_primary"].health_check_path == "/health" &&
      module.this.endpoint_groups["web_api:eu_primary"].health_check_interval_seconds == 10 &&
      module.this.endpoint_groups["web_api:eu_primary"].threshold_count == 5 &&
      module.this.endpoint_groups["web_api:eu_primary"].traffic_dial_percentage == 75
    )
    error_message = "Explicit health-check and traffic-dial settings must be normalized for upstream v3."
  }

  assert {
    condition = (
      module.this.endpoint_groups["web_api:us-secondary"].health_check_protocol == "TCP" &&
      module.this.endpoint_groups["web_api:us-secondary"].health_check_interval_seconds == 30 &&
      module.this.endpoint_groups["web_api:us-secondary"].threshold_count == 3 &&
      module.this.endpoint_groups["web_api:us-secondary"].traffic_dial_percentage == 100
    )
    error_message = "Endpoint-group health and traffic defaults must reach upstream v3."
  }

  assert {
    condition = (
      one(module.this.endpoint_groups["web_api:eu_primary"].endpoint_configuration).endpoint_id == "arn:aws:elasticloadbalancing:eu-central-1:123456789012:loadbalancer/app/example/0123456789abcdef" &&
      one(module.this.endpoint_groups["web_api:eu_primary"].endpoint_configuration).weight == 200 &&
      one(module.this.endpoint_groups["web_api:eu_primary"].endpoint_configuration).client_ip_preservation_enabled
    )
    error_message = "Explicit endpoint settings must reach upstream endpoint_configuration blocks."
  }

  assert {
    condition     = one(module.this.endpoint_groups["web_api:us-secondary"].endpoint_configuration).weight == 128
    error_message = "Endpoint weight must default to 128 before upstream normalization."
  }

  assert {
    condition     = one(module.this.endpoint_groups["web_api:eu_primary"].port_override).listener_port == 443 && one(module.this.endpoint_groups["web_api:eu_primary"].port_override).endpoint_port == 8443 && length(module.this.endpoint_groups["dns-edge:edge_primary"].port_override) == 0
    error_message = "Port overrides must normalize to upstream blocks and default to an empty collection."
  }

  assert {
    condition = (
      var.listeners["dns-edge"].endpoint_groups.edge_primary.health_check.port == null &&
      var.listeners["dns-edge"].endpoint_groups.edge_primary.health_check.path == null &&
      one(var.listeners["dns-edge"].endpoint_groups.edge_primary.endpoints).client_ip_preservation_enabled == null &&
      length(var.listeners["dns-edge"].endpoint_groups.edge_primary.port_overrides) == 0
    )
    error_message = "Nullable health fields and optional arrays must preserve their public defaults."
  }

  assert {
    condition = (
      !contains(keys(local.listeners["web_api"].endpoint_groups["us-secondary"]), "health_check_port") &&
      !contains(keys(local.listeners["web_api"].endpoint_groups["us-secondary"]), "health_check_path") &&
      !contains(keys(one(local.listeners["web_api"].endpoint_groups["us-secondary"].endpoint_configuration)), "client_ip_preservation_enabled") &&
      !contains(keys(local.listeners["dns-edge"].endpoint_groups["edge_primary"]), "health_check_port") &&
      !contains(keys(local.listeners["dns-edge"].endpoint_groups["edge_primary"]), "health_check_path") &&
      !contains(keys(one(local.listeners["dns-edge"].endpoint_groups["edge_primary"].endpoint_configuration)), "client_ip_preservation_enabled")
    )
    error_message = "Nullable health and endpoint fields must be omitted from normalized upstream child-module values."
  }

  assert {
    condition     = output.accelerator_arn == "arn:aws:globalaccelerator::123456789012:accelerator/example" && output.dns_name == "a1234567890example.awsglobalaccelerator.com" && output.hosted_zone_id == "Z2BJ6XQ5FK7U4H"
    error_message = "Accelerator identity outputs must expose the overridden upstream values."
  }

  assert {
    condition     = output.dual_stack_dns_name == null
    error_message = "IPv4 accelerators must expose null for dual_stack_dns_name."
  }

  assert {
    condition     = length(output.ip_sets) == 1 && toset(keys(output.ip_sets[0])) == toset(["ip_addresses", "ip_family"]) && output.ip_sets[0].ip_family == "IPv4" && output.ip_sets[0].ip_addresses == ["192.0.2.10", "192.0.2.11"]
    error_message = "The public IP-set list must retain its exact object shape and IPv4 addresses."
  }

  assert {
    condition = (
      toset(keys(output.listener_arns)) == toset(["web_api", "dns-edge"]) &&
      output.listener_arns["web_api"] == "arn:aws:globalaccelerator::123456789012:accelerator/example/listener/web-api" &&
      output.listener_arns["dns-edge"] == "arn:aws:globalaccelerator::123456789012:accelerator/example/listener/dns-edge"
    )
    error_message = "Listener ARN output keys and values must remain stable."
  }

  assert {
    condition = (
      toset(keys(output.endpoint_group_arns)) == toset(["web_api", "dns-edge"]) &&
      toset(keys(output.endpoint_group_arns["web_api"])) == toset(["eu_primary", "us-secondary"]) &&
      toset(keys(output.endpoint_group_arns["dns-edge"])) == toset(["edge_primary"]) &&
      output.endpoint_group_arns["web_api"]["eu_primary"] == "arn:aws:globalaccelerator::123456789012:accelerator/example/listener/web-api/endpoint-group/eu-primary" &&
      output.endpoint_group_arns["web_api"]["us-secondary"] == "arn:aws:globalaccelerator::123456789012:accelerator/example/listener/web-api/endpoint-group/us-secondary" &&
      output.endpoint_group_arns["dns-edge"]["edge_primary"] == "arn:aws:globalaccelerator::123456789012:accelerator/example/listener/dns-edge/endpoint-group/edge-primary"
    )
    error_message = "Endpoint-group ARN outputs must reconstruct the exact nested logical key sets."
  }
}

run "exposes_dual_stack_addresses" {
  command = plan

  variables {
    ip_address_type = "DUAL_STACK"
  }

  override_resource {
    target = module.this.aws_globalaccelerator_accelerator.this[0]
    values = {
      arn                 = "arn:aws:globalaccelerator::123456789012:accelerator/dual-stack"
      dns_name            = "a1234567890example.awsglobalaccelerator.com"
      dual_stack_dns_name = "a1234567890example.dualstack.awsglobalaccelerator.com"
      hosted_zone_id      = "Z2BJ6XQ5FK7U4H"
      ip_sets = [
        {
          ip_addresses = ["192.0.2.10", "192.0.2.11"]
          ip_family    = "IPv4"
        },
        {
          ip_addresses = ["2001:db8::10", "2001:db8::11"]
          ip_family    = "IPv6"
        }
      ]
    }
  }

  assert {
    condition     = output.dual_stack_dns_name == "a1234567890example.dualstack.awsglobalaccelerator.com"
    error_message = "Dual Stack accelerators must expose the upstream dual-stack DNS name."
  }

  assert {
    condition     = toset([for ip_set in output.ip_sets : ip_set.ip_family]) == toset(["IPv4", "IPv6"])
    error_message = "Dual Stack output must contain complete IPv4 and IPv6 IP sets."
  }

  assert {
    condition     = one([for ip_set in output.ip_sets : ip_set if ip_set.ip_family == "IPv4"]).ip_addresses == ["192.0.2.10", "192.0.2.11"]
    error_message = "Dual Stack output must expose the overridden IPv4 addresses."
  }

  assert {
    condition     = one([for ip_set in output.ip_sets : ip_set if ip_set.ip_family == "IPv6"]).ip_addresses == ["2001:db8::10", "2001:db8::11"]
    error_message = "Dual Stack output must expose the overridden IPv6 addresses."
  }
}
