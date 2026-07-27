locals {
  listener_security_group_ports = flatten([
    for listener_key, listener in var.listeners : [
      for protocol in upper(listener.protocol) == "TCP_UDP" ? ["tcp", "udp"] : upper(listener.protocol) == "UDP" ? ["udp"] : ["tcp"] : {
        key      = listener_key
        port     = listener.port
        protocol = protocol
      }
    ]
  ])

  security_group_ingress_ipv4_rules = {
    for rule in flatten([
      for listener in local.listener_security_group_ports : [
        for cidr in var.allowed_cidr_blocks : {
          key = "${listener.key}-${listener.protocol}-ipv4-${substr(sha1(cidr), 0, 8)}"
          value = {
            cidr_ipv4   = cidr
            description = "Allow ${listener.protocol} ${listener.port} from ${cidr}"
            from_port   = listener.port
            ip_protocol = listener.protocol
            to_port     = listener.port
          }
        }
      ]
    ]) : rule.key => rule.value
  }

  security_group_ingress_ipv6_rules = {
    for rule in flatten([
      for listener in local.listener_security_group_ports : [
        for cidr in var.allowed_ipv6_cidr_blocks : {
          key = "${listener.key}-${listener.protocol}-ipv6-${substr(sha1(cidr), 0, 8)}"
          value = {
            cidr_ipv6   = cidr
            description = "Allow ${listener.protocol} ${listener.port} from ${cidr}"
            from_port   = listener.port
            ip_protocol = listener.protocol
            to_port     = listener.port
          }
        }
      ]
    ]) : rule.key => rule.value
  }

  security_group_egress_ipv4_rules = {
    for index, cidr in var.egress_cidr_blocks : "egress-ipv4-${index}" => {
      cidr_ipv4   = cidr
      description = "Allow outbound IPv4 traffic to ${cidr}"
      ip_protocol = "-1"
    }
  }

  security_group_egress_ipv6_rules = {
    for index, cidr in var.egress_ipv6_cidr_blocks : "egress-ipv6-${index}" => {
      cidr_ipv6   = cidr
      description = "Allow outbound IPv6 traffic to ${cidr}"
      ip_protocol = "-1"
    }
  }

  listeners = {
    for listener_key, listener in var.listeners : listener_key => merge(
      {
        forward = {
          target_group_key = listener.target_group_key
        }
        port     = listener.port
        protocol = upper(listener.protocol)
      },
      listener.certificate_arn == null ? {} : { certificate_arn = listener.certificate_arn },
      listener.ssl_policy == null ? {} : { ssl_policy = listener.ssl_policy },
      listener.alpn_policy == null ? {} : { alpn_policy = listener.alpn_policy },
      listener.tcp_idle_timeout_seconds == null ? {} : { tcp_idle_timeout_seconds = listener.tcp_idle_timeout_seconds }
    )
  }

  target_groups = {
    for target_group_key, target_group in var.target_groups : target_group_key => merge(
      {
        create_attachment = false
        health_check      = target_group.health_check
        port              = target_group.port
        protocol          = upper(target_group.protocol)
        target_type       = lower(target_group.target_type)
        vpc_id            = var.vpc_id
      },
      target_group.name_prefix != null ? { name_prefix = target_group.name_prefix } : { name = coalesce(target_group.name, substr("${var.name}-${target_group_key}", 0, 32)) },
      target_group.deregistration_delay == null ? {} : { deregistration_delay = target_group.deregistration_delay },
      target_group.preserve_client_ip == null ? {} : { preserve_client_ip = target_group.preserve_client_ip },
      target_group.proxy_protocol_v2 == null ? {} : { proxy_protocol_v2 = target_group.proxy_protocol_v2 }
    )
  }

  target_group_attachments = flatten([
    for target_group_key, target_group in var.target_groups : [
      for target_key, target in target_group.targets : {
        key = "${target_group_key}-${target_key}"
        value = merge(
          {
            target_group_key = target_group_key
            target_id        = target.target_id
          },
          target.port == null ? {} : { port = target.port },
          target.availability_zone == null ? {} : { availability_zone = target.availability_zone }
        )
      }
    ]
  ])
}

module "this" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.17"

  name               = var.name
  load_balancer_type = "network"
  internal           = var.internal
  ip_address_type    = var.ip_address_type
  subnets            = var.subnet_ids
  vpc_id             = var.vpc_id

  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection

  listeners                           = local.listeners
  target_groups                       = local.target_groups
  additional_target_group_attachments = { for attachment in local.target_group_attachments : attachment.key => attachment.value }

  create_security_group          = var.create_security_group
  security_group_name            = coalesce(var.security_group_name, var.name)
  security_group_use_name_prefix = var.security_group_use_name_prefix
  security_group_description     = coalesce(var.security_group_description, "Security group for ${var.name} Network Load Balancer")
  security_groups                = var.security_group_ids
  security_group_ingress_rules   = merge(local.security_group_ingress_ipv4_rules, local.security_group_ingress_ipv6_rules)
  security_group_egress_rules    = merge(local.security_group_egress_ipv4_rules, local.security_group_egress_ipv6_rules)
  security_group_tags            = var.tags

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "target_unhealthy" {
  for_each = var.alarms.enabled ? var.target_groups : {}

  alarm_name                = "${var.alarms.name_prefix}${var.name}-${each.key}-unhealthy-targets"
  alarm_description         = "Network Load Balancer target group ${each.key} has unhealthy targets."
  namespace                 = "AWS/NetworkELB"
  metric_name               = "UnHealthyHostCount"
  comparison_operator       = var.alarms.comparison_operator
  evaluation_periods        = var.alarms.evaluation_periods
  datapoints_to_alarm       = var.alarms.datapoints_to_alarm
  period                    = var.alarms.period
  statistic                 = var.alarms.statistic
  threshold                 = var.alarms.threshold
  treat_missing_data        = var.alarms.treat_missing_data
  alarm_actions             = var.alarms.alarm_actions
  ok_actions                = var.alarms.ok_actions
  insufficient_data_actions = var.alarms.insufficient_data_actions

  dimensions = {
    LoadBalancer = module.this.arn_suffix
    TargetGroup  = module.this.target_groups[each.key].arn_suffix
  }

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}-unhealthy-targets"
  })
}
