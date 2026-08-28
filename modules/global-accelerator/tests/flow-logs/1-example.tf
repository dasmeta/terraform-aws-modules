module "global_accelerator" {
  source = "../.."

  name = "example-flow-logs-accelerator"

  listeners = {
    dns = {
      protocol = "UDP"
      port_ranges = [{
        from_port = 53
        to_port   = 53
      }]

      endpoint_groups = {
        eu_west = {
          endpoint_group_region = "eu-west-1"
          endpoints = [{
            endpoint_id = "i-0123456789abcdef0"
            weight      = 64
          }]
        }
      }
    }
  }

  flow_logs = {
    enabled   = true
    s3_bucket = "example-global-accelerator-flow-logs"
    s3_prefix = "global-accelerator"
  }
}
