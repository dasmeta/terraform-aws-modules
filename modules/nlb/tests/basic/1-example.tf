module "this" {
  source = "../.."

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

      health_check = {
        protocol = "TCP"
        port     = "traffic-port"
      }

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

  tags = {
    Environment = "test"
  }
}
