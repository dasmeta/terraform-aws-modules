mock_provider "aws" {
  override_during = plan

  mock_resource "aws_globalaccelerator_accelerator" {
    defaults = {
      arn                 = "arn:aws:globalaccelerator::123456789012:accelerator/flow-logs"
      dns_name            = "flow-logs.awsglobalaccelerator.com"
      dual_stack_dns_name = "flow-logs.dualstack.awsglobalaccelerator.com"
      hosted_zone_id      = "Z2BJ6XQ5FK7U4H"
      ip_sets = [{
        ip_addresses = ["192.0.2.30", "192.0.2.31"]
        ip_family    = "IPv4"
      }]
    }
  }

  mock_resource "aws_globalaccelerator_listener" {
    defaults = {
      id  = "arn:aws:globalaccelerator::123456789012:accelerator/flow-logs/listener/dns"
      arn = "arn:aws:globalaccelerator::123456789012:accelerator/flow-logs/listener/dns"
    }
  }

  mock_resource "aws_globalaccelerator_endpoint_group" {
    defaults = {
      arn = "arn:aws:globalaccelerator::123456789012:accelerator/flow-logs/listener/dns/endpoint-group/eu-west"
    }
  }
}

run "flow_logs_fixture_plans" {
  command = plan

  module {
    source = "./tests/flow-logs"
  }

  assert {
    condition     = output.accelerator_arn == "arn:aws:globalaccelerator::123456789012:accelerator/flow-logs" && output.dns_name == "flow-logs.awsglobalaccelerator.com"
    error_message = "The flow-log fixture must wire accelerator identity outputs."
  }

  assert {
    condition     = output.dual_stack_dns_name == null && length(output.ip_sets) == 1 && output.ip_sets[0].ip_addresses == tolist(["192.0.2.30", "192.0.2.31"])
    error_message = "The flow-log fixture must retain default IPv4 output behavior."
  }

  assert {
    condition     = toset(keys(output.listener_arns)) == toset(["dns"]) && toset(keys(output.endpoint_group_arns["dns"])) == toset(["eu_west"])
    error_message = "The flow-log fixture must retain its listener and endpoint-group logical keys."
  }
}
