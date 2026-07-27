# AWS Network Load Balancer

This module creates a reusable AWS Network Load Balancer with listener, target group, target attachment, security group allowlist, and target-health alarm support.

It wraps `terraform-aws-modules/alb/aws` with `load_balancer_type = "network"` and exposes a smaller interface for common NLB use cases.

## Usage

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
}
```

## Security Groups

When `create_security_group` is true, the module creates and attaches a Network Load Balancer security group. Listener ports are opened only to `allowed_cidr_blocks` and `allowed_ipv6_cidr_blocks`.

For a single trusted IP, pass a `/32` CIDR:

```hcl
allowed_cidr_blocks = ["203.0.113.10/32"]
```

AWS requires Network Load Balancer security groups to be associated when the load balancer is created. If an NLB is created without security groups, they cannot be added to that NLB later without replacement. Keep `create_security_group = true` or pass `security_group_ids` during initial creation when allowlisting is required.

## Target Health Alarms

When `alarms.enabled` is true, the module creates one CloudWatch alarm per target group for `AWS/NetworkELB` `UnHealthyHostCount`.

Notification actions are caller-owned. Pass SNS topic ARNs or other CloudWatch alarm action ARNs with `alarms.alarm_actions`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.99 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.56.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_this"></a> [this](#module\_this) | terraform-aws-modules/alb/aws | ~> 9.17 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_cloudwatch_metric_alarm.target_unhealthy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_alarms"></a> [alarms](#input\_alarms) | Target-health CloudWatch alarm configuration. Alarm actions are caller-owned. | <pre>object({<br/>    enabled                   = optional(bool, false)<br/>    alarm_actions             = optional(list(string), [])<br/>    ok_actions                = optional(list(string), [])<br/>    insufficient_data_actions = optional(list(string), [])<br/>    name_prefix               = optional(string, "")<br/>    threshold                 = optional(number, 0)<br/>    comparison_operator       = optional(string, "GreaterThanThreshold")<br/>    evaluation_periods        = optional(number, 1)<br/>    datapoints_to_alarm       = optional(number)<br/>    period                    = optional(number, 60)<br/>    statistic                 = optional(string, "Maximum")<br/>    treat_missing_data        = optional(string, "notBreaching")<br/>  })</pre> | <pre>{<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | IPv4 CIDR blocks allowed to reach listener ports on the module-managed security group. | `list(string)` | `[]` | no |
| <a name="input_allowed_ipv6_cidr_blocks"></a> [allowed\_ipv6\_cidr\_blocks](#input\_allowed\_ipv6\_cidr\_blocks) | IPv6 CIDR blocks allowed to reach listener ports on the module-managed security group. | `list(string)` | `[]` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Whether to create and attach a module-managed security group to the Network Load Balancer. | `bool` | `true` | no |
| <a name="input_egress_cidr_blocks"></a> [egress\_cidr\_blocks](#input\_egress\_cidr\_blocks) | IPv4 CIDR blocks allowed for outbound traffic from the module-managed security group. | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_egress_ipv6_cidr_blocks"></a> [egress\_ipv6\_cidr\_blocks](#input\_egress\_ipv6\_cidr\_blocks) | IPv6 CIDR blocks allowed for outbound traffic from the module-managed security group. | `list(string)` | `[]` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Whether cross-zone load balancing is enabled for the Network Load Balancer. | `bool` | `true` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Whether deletion protection is enabled for the Network Load Balancer. | `bool` | `false` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Whether the Network Load Balancer is internal. | `bool` | `true` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | IP address type for the Network Load Balancer. | `string` | `"ipv4"` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | Map of Network Load Balancer listeners keyed by logical listener name. | <pre>map(object({<br/>    port                     = number<br/>    protocol                 = optional(string, "TCP")<br/>    target_group_key         = string<br/>    certificate_arn          = optional(string)<br/>    ssl_policy               = optional(string)<br/>    alpn_policy              = optional(string)<br/>    tcp_idle_timeout_seconds = optional(number)<br/>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Network Load Balancer. | `string` | n/a | yes |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | Description for the module-managed security group. | `string` | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Existing security group IDs to attach to the Network Load Balancer. | `list(string)` | `[]` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Name for the module-managed security group. Defaults to name. | `string` | `null` | no |
| <a name="input_security_group_use_name_prefix"></a> [security\_group\_use\_name\_prefix](#input\_security\_group\_use\_name\_prefix) | Whether security\_group\_name is used as a name prefix. | `bool` | `false` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs to attach to the Network Load Balancer. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to supported resources. | `map(string)` | `{}` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | Map of target groups keyed by logical target group name. | <pre>map(object({<br/>    name                 = optional(string)<br/>    name_prefix          = optional(string)<br/>    port                 = number<br/>    protocol             = optional(string, "TCP")<br/>    target_type          = optional(string, "ip")<br/>    deregistration_delay = optional(number)<br/>    preserve_client_ip   = optional(bool)<br/>    proxy_protocol_v2    = optional(bool)<br/>    health_check = optional(object({<br/>      enabled             = optional(bool)<br/>      healthy_threshold   = optional(number)<br/>      interval            = optional(number)<br/>      matcher             = optional(string)<br/>      path                = optional(string)<br/>      port                = optional(string)<br/>      protocol            = optional(string)<br/>      timeout             = optional(number)<br/>      unhealthy_threshold = optional(number)<br/>    }), {})<br/>    targets = optional(map(object({<br/>      target_id         = string<br/>      port              = optional(number)<br/>      availability_zone = optional(string)<br/>    })), {})<br/>  }))</pre> | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where target groups and optional security group are created. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_lb_arn"></a> [lb\_arn](#output\_lb\_arn) | ARN of the Network Load Balancer. |
| <a name="output_lb_arn_suffix"></a> [lb\_arn\_suffix](#output\_lb\_arn\_suffix) | ARN suffix of the Network Load Balancer for CloudWatch dimensions. |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | DNS name of the Network Load Balancer. |
| <a name="output_lb_zone_id"></a> [lb\_zone\_id](#output\_lb\_zone\_id) | Route53 zone ID of the Network Load Balancer. |
| <a name="output_listener_arns"></a> [listener\_arns](#output\_listener\_arns) | ARNs of listeners created by this module. |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | ARN of the module-managed security group, when created. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the module-managed security group, when created. |
| <a name="output_target_group_arn_suffixes"></a> [target\_group\_arn\_suffixes](#output\_target\_group\_arn\_suffixes) | ARN suffixes of target groups for CloudWatch dimensions. |
| <a name="output_target_group_arns"></a> [target\_group\_arns](#output\_target\_group\_arns) | ARNs of target groups created by this module. |
| <a name="output_target_unhealthy_alarm_arns"></a> [target\_unhealthy\_alarm\_arns](#output\_target\_unhealthy\_alarm\_arns) | ARNs of target unhealthy CloudWatch alarms. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
