mock_provider "aws" {
  override_during = plan

  mock_resource "aws_globalaccelerator_accelerator" {
    defaults = {
      arn                 = "arn:aws:globalaccelerator::123456789012:accelerator/basic"
      dns_name            = "basic.awsglobalaccelerator.com"
      dual_stack_dns_name = "basic.dualstack.awsglobalaccelerator.com"
      hosted_zone_id      = "Z2BJ6XQ5FK7U4H"
      ip_sets = [{
        ip_addresses = ["192.0.2.20", "192.0.2.21"]
        ip_family    = "IPv4"
      }]
    }
  }

  mock_resource "aws_globalaccelerator_listener" {
    defaults = {
      id  = "arn:aws:globalaccelerator::123456789012:accelerator/basic/listener/https"
      arn = "arn:aws:globalaccelerator::123456789012:accelerator/basic/listener/https"
    }
  }

  mock_resource "aws_globalaccelerator_endpoint_group" {
    defaults = {
      arn = "arn:aws:globalaccelerator::123456789012:accelerator/basic/listener/https/endpoint-group/eu-central"
    }
  }
}

run "basic_fixture_plans" {
  command = plan

  module {
    source = "./tests/basic"
  }

  assert {
    condition     = output.accelerator_arn == "arn:aws:globalaccelerator::123456789012:accelerator/basic" && output.dns_name == "basic.awsglobalaccelerator.com" && output.hosted_zone_id == "Z2BJ6XQ5FK7U4H"
    error_message = "The basic fixture must wire accelerator identity outputs."
  }

  assert {
    condition     = output.dual_stack_dns_name == null && length(output.ip_sets) == 1 && output.ip_sets[0].ip_family == "IPv4"
    error_message = "The basic fixture must retain default IPv4 output behavior."
  }

  assert {
    condition     = toset(keys(output.listener_arns)) == toset(["https"]) && toset(keys(output.endpoint_group_arns)) == toset(["https"]) && toset(keys(output.endpoint_group_arns["https"])) == toset(["eu_central"])
    error_message = "The basic fixture must retain its listener and endpoint-group logical keys."
  }
}
