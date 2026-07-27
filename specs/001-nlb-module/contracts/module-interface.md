# Module Interface Contract: `modules/nlb`

## Minimal Example

```hcl
module "nlb" {
  source = "dasmeta/modules/aws//modules/nlb"

  name       = "example-nlb"
  vpc_id     = "vpc-12345678"
  subnet_ids = ["subnet-11111111", "subnet-22222222"]

  allowed_cidr_blocks = ["203.0.113.10/32"]

  listeners = {
    tcp = {
      port             = 3306
      protocol         = "TCP"
      target_group_key = "tcp"
    }
  }

  target_groups = {
    tcp = {
      port        = 3306
      protocol    = "TCP"
      target_type = "ip"
      targets = {
        primary = {
          target_id = "10.0.1.10"
          port      = 3306
        }
      }
    }
  }

  alarms = {
    enabled       = true
    alarm_actions = ["arn:aws:sns:eu-central-1:123456789012:example-alerts"]
  }
}
```

## Required Outputs

- `lb_arn`
- `lb_arn_suffix`
- `lb_dns_name`
- `lb_zone_id`
- `listener_arns`
- `target_group_arns`
- `target_group_arn_suffixes`
- `security_group_id`
- `target_unhealthy_alarm_arns`
