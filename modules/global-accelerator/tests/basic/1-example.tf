module "global_accelerator" {
  source = "../.."

  name = "example-basic-accelerator"

  listeners = {
    https = {
      port_ranges = [{
        from_port = 443
        to_port   = 443
      }]

      endpoint_groups = {
        eu_central = {
          endpoint_group_region = "eu-central-1"
          endpoints = [{
            endpoint_id = "arn:aws:elasticloadbalancing:eu-central-1:123456789012:loadbalancer/app/example/0123456789abcdef"
          }]
        }
      }
    }
  }
}
