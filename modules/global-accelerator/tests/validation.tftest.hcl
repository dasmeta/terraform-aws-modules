mock_provider "aws" {
  override_during = plan

  mock_resource "aws_globalaccelerator_accelerator" {
    defaults = {
      arn                 = "arn:aws:globalaccelerator::123456789012:accelerator/validation"
      dns_name            = "validation.awsglobalaccelerator.com"
      dual_stack_dns_name = "validation.dualstack.awsglobalaccelerator.com"
      hosted_zone_id      = "Z2BJ6XQ5FK7U4H"
      ip_sets = [{
        ip_addresses = ["192.0.2.40", "192.0.2.41"]
        ip_family    = "IPv4"
      }]
    }
  }
}

variables {
  name = "valid-accelerator"

  listeners = {
    web = {
      port_ranges = [{
        from_port = 443
        to_port   = 443
      }]
      endpoint_groups = {
        primary = {
          endpoint_group_region = "eu-central-1"
          endpoints = [{
            endpoint_id = "arn:aws:elasticloadbalancing:eu-central-1:123456789012:loadbalancer/app/example/0123456789abcdef"
          }]
        }
      }
    }
  }
}

run "accepts_minimum_length_name" {
  command = plan

  variables {
    name = "a"
  }
}

run "accepts_maximum_length_name" {
  command = plan

  variables {
    name = join("", [for _ in range(64) : "a"])
  }
}

run "rejects_empty_name" {
  command = plan

  variables {
    name = ""
  }

  expect_failures = [var.name]
}

run "rejects_too_long_name" {
  command = plan

  variables {
    name = join("", [for _ in range(65) : "a"])
  }

  expect_failures = [var.name]
}

run "rejects_leading_hyphen_name" {
  command = plan

  variables {
    name = "-invalid"
  }

  expect_failures = [var.name]
}

run "rejects_trailing_hyphen_name" {
  command = plan

  variables {
    name = "invalid-"
  }

  expect_failures = [var.name]
}

run "rejects_invalid_name_character" {
  command = plan

  variables {
    name = "invalid.name"
  }

  expect_failures = [var.name]
}

run "rejects_invalid_ip_type" {
  command = plan

  variables {
    ip_address_type = "ipv6"
  }

  expect_failures = [var.ip_address_type]
}

run "rejects_empty_listeners" {
  command = plan

  variables {
    listeners = {}
  }

  expect_failures = [var.listeners]
}

run "rejects_empty_listener_key" {
  command = plan

  variables {
    listeners = {
      "" = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_colon_in_listener_key" {
  command = plan

  variables {
    listeners = {
      "web:tcp" = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_empty_endpoint_group_key" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          "" = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_colon_in_endpoint_group_key" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          "eu:primary" = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_invalid_listener_protocol" {
  command = plan

  variables {
    listeners = {
      web = {
        protocol    = "HTTP"
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_invalid_client_affinity" {
  command = plan

  variables {
    listeners = {
      web = {
        client_affinity = "COOKIE"
        port_ranges     = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_empty_port_ranges" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = []
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_too_many_port_ranges" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [for port in range(100, 111) : {
          from_port = port
          to_port   = port
        }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_port_below_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 0, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_port_above_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 65536 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_fractional_port" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443.5, to_port = 444 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_reversed_port_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 80 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_overlapping_ranges_within_listener" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [
          { from_port = 80, to_port = 90 },
          { from_port = 90, to_port = 100 }
        ]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_overlapping_ranges_across_listeners" {
  command = plan

  variables {
    listeners = {
      web = {
        protocol    = "TCP"
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
      admin = {
        protocol    = "UDP"
        port_ranges = [{ from_port = 440, to_port = 450 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "us-east-1"
            endpoints             = [{ endpoint_id = "eipalloc-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_empty_endpoint_groups" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges     = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {}
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_empty_endpoint_group_region" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = ""
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_whitespace_endpoint_group_region" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "   "
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_duplicate_region_per_listener" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
          secondary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "eipalloc-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_empty_endpoints" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = []
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_too_many_endpoints" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints = [for _ in range(11) : {
              endpoint_id = "i-0123456789abcdef0"
            }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_empty_endpoint_id" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_whitespace_endpoint_id" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "   " }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_too_long_endpoint_id" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints = [{
              endpoint_id = join("", [for _ in range(256) : "a"])
            }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_weight_below_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0", weight = -1 }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_weight_above_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0", weight = 256 }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_fractional_weight" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0", weight = 127.5 }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_traffic_dial_below_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region   = "eu-central-1"
            traffic_dial_percentage = -0.1
            endpoints               = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_traffic_dial_above_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region   = "eu-central-1"
            traffic_dial_percentage = 100.1
            endpoints               = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_invalid_health_protocol" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check          = { protocol = "UDP" }
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_invalid_health_interval" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check          = { interval_seconds = 20 }
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "accepts_http_health_check_without_path" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check          = { protocol = "HTTP" }
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }
}

run "rejects_health_port_below_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check          = { port = 0 }
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_health_port_above_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check          = { port = 65536 }
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_fractional_health_port" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check          = { port = 443.5 }
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_health_threshold_below_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check          = { threshold_count = 0 }
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_health_threshold_above_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check          = { threshold_count = 11 }
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_fractional_health_threshold" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check          = { threshold_count = 3.5 }
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_empty_http_health_path" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check = {
              protocol = "HTTP"
              path     = ""
            }
            endpoints = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_relative_http_health_path" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check = {
              protocol = "HTTP"
              path     = "health"
            }
            endpoints = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_unsafe_http_health_path" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check = {
              protocol = "HTTPS"
              path     = "/health check"
            }
            endpoints = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_too_long_http_health_path" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check = {
              protocol = "HTTPS"
              path     = "/${join("", [for _ in range(255) : "a"])}"
            }
            endpoints = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_tcp_health_path" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            health_check = {
              protocol = "TCP"
              path     = "/health"
            }
            endpoints = [{ endpoint_id = "i-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_too_many_port_overrides" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 100, to_port = 110 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
            port_overrides = [for port in range(100, 111) : {
              listener_port = port
              endpoint_port = port + 8000
            }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_override_listener_port_below_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
            port_overrides        = [{ listener_port = 0, endpoint_port = 8443 }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_override_endpoint_port_above_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
            port_overrides        = [{ listener_port = 443, endpoint_port = 65536 }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_fractional_override_listener_port" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 444 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
            port_overrides        = [{ listener_port = 443.5, endpoint_port = 8443 }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_fractional_override_endpoint_port" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
            port_overrides        = [{ listener_port = 443, endpoint_port = 8443.5 }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_foreign_override_listener_port" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
            port_overrides        = [{ listener_port = 80, endpoint_port = 8443 }]
          }
        }
      }
      http = {
        port_ranges = [{ from_port = 80, to_port = 80 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "us-east-1"
            endpoints             = [{ endpoint_id = "eipalloc-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_override_endpoint_port_in_listener_range" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
            port_overrides        = [{ listener_port = 443, endpoint_port = 80 }]
          }
        }
      }
      http = {
        port_ranges = [{ from_port = 80, to_port = 80 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "us-east-1"
            endpoints             = [{ endpoint_id = "eipalloc-0123456789abcdef0" }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_duplicate_identical_override_mapping" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
            port_overrides = [
              { listener_port = 443, endpoint_port = 8443 },
              { listener_port = 443, endpoint_port = 8443 }
            ]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_duplicate_override_listener_port" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
            port_overrides = [
              { listener_port = 443, endpoint_port = 8443 },
              { listener_port = 443, endpoint_port = 9443 }
            ]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_duplicate_override_endpoint_port" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 444 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
            port_overrides = [
              { listener_port = 443, endpoint_port = 8443 },
              { listener_port = 444, endpoint_port = 8443 }
            ]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_cross_group_conflicting_mapping" {
  command = plan

  variables {
    listeners = {
      web = {
        port_ranges = [{ from_port = 443, to_port = 443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "eu-central-1"
            endpoints             = [{ endpoint_id = "i-0123456789abcdef0" }]
            port_overrides        = [{ listener_port = 443, endpoint_port = 8080 }]
          }
        }
      }
      admin = {
        port_ranges = [{ from_port = 8443, to_port = 8443 }]
        endpoint_groups = {
          primary = {
            endpoint_group_region = "us-east-1"
            endpoints             = [{ endpoint_id = "eipalloc-0123456789abcdef0" }]
            port_overrides        = [{ listener_port = 8443, endpoint_port = 8080 }]
          }
        }
      }
    }
  }

  expect_failures = [var.listeners]
}

run "rejects_flow_logs_without_bucket" {
  command = plan

  variables {
    flow_logs = {
      enabled   = true
      s3_prefix = "global-accelerator"
    }
  }

  expect_failures = [var.flow_logs]
}

run "rejects_flow_logs_with_empty_bucket" {
  command = plan

  variables {
    flow_logs = {
      enabled   = true
      s3_bucket = ""
      s3_prefix = "global-accelerator"
    }
  }

  expect_failures = [var.flow_logs]
}

run "rejects_flow_logs_with_whitespace_bucket" {
  command = plan

  variables {
    flow_logs = {
      enabled   = true
      s3_bucket = "   "
      s3_prefix = "global-accelerator"
    }
  }

  expect_failures = [var.flow_logs]
}

run "rejects_flow_logs_without_prefix" {
  command = plan

  variables {
    flow_logs = {
      enabled   = true
      s3_bucket = "example-global-accelerator-flow-logs"
    }
  }

  expect_failures = [var.flow_logs]
}

run "rejects_flow_logs_with_empty_prefix" {
  command = plan

  variables {
    flow_logs = {
      enabled   = true
      s3_bucket = "example-global-accelerator-flow-logs"
      s3_prefix = ""
    }
  }

  expect_failures = [var.flow_logs]
}

run "rejects_flow_logs_with_whitespace_prefix" {
  command = plan

  variables {
    flow_logs = {
      enabled   = true
      s3_bucket = "example-global-accelerator-flow-logs"
      s3_prefix = "   "
    }
  }

  expect_failures = [var.flow_logs]
}

run "rejects_flow_logs_with_too_long_bucket" {
  command = plan

  variables {
    flow_logs = {
      enabled   = true
      s3_bucket = join("", [for _ in range(256) : "a"])
      s3_prefix = "global-accelerator"
    }
  }

  expect_failures = [var.flow_logs]
}

run "rejects_flow_logs_with_too_long_prefix" {
  command = plan

  variables {
    flow_logs = {
      enabled   = true
      s3_bucket = "example-global-accelerator-flow-logs"
      s3_prefix = join("", [for _ in range(256) : "a"])
    }
  }

  expect_failures = [var.flow_logs]
}
