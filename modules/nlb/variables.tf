variable "name" {
  type        = string
  description = "Name of the Network Load Balancer."
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where target groups and optional security group are created."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs to attach to the Network Load Balancer."
}

variable "internal" {
  type        = bool
  default     = true
  description = "Whether the Network Load Balancer is internal."
}

variable "enable_deletion_protection" {
  type        = bool
  default     = false
  description = "Whether deletion protection is enabled for the Network Load Balancer."
}

variable "enable_cross_zone_load_balancing" {
  type        = bool
  default     = true
  description = "Whether cross-zone load balancing is enabled for the Network Load Balancer."
}

variable "ip_address_type" {
  type        = string
  default     = "ipv4"
  description = "IP address type for the Network Load Balancer."

  validation {
    condition     = contains(["ipv4", "dualstack"], var.ip_address_type)
    error_message = "ip_address_type must be either ipv4 or dualstack."
  }
}

variable "listeners" {
  type = map(object({
    port                     = number
    protocol                 = optional(string, "TCP")
    target_group_key         = string
    certificate_arn          = optional(string)
    ssl_policy               = optional(string)
    alpn_policy              = optional(string)
    tcp_idle_timeout_seconds = optional(number)
  }))
  description = "Map of Network Load Balancer listeners keyed by logical listener name."

  validation {
    condition = alltrue([
      for listener in values(var.listeners) : contains(["TCP", "TLS", "UDP", "TCP_UDP"], upper(listener.protocol))
    ])
    error_message = "Listener protocol must be one of TCP, TLS, UDP, or TCP_UDP."
  }

  validation {
    condition = alltrue([
      for listener in values(var.listeners) : upper(listener.protocol) != "TLS" || listener.certificate_arn != null
    ])
    error_message = "TLS listeners must include certificate_arn."
  }
}

variable "target_groups" {
  type = map(object({
    name                 = optional(string)
    name_prefix          = optional(string)
    port                 = number
    protocol             = optional(string, "TCP")
    target_type          = optional(string, "ip")
    deregistration_delay = optional(number)
    preserve_client_ip   = optional(bool)
    proxy_protocol_v2    = optional(bool)
    health_check = optional(object({
      enabled             = optional(bool)
      healthy_threshold   = optional(number)
      interval            = optional(number)
      matcher             = optional(string)
      path                = optional(string)
      port                = optional(string)
      protocol            = optional(string)
      timeout             = optional(number)
      unhealthy_threshold = optional(number)
    }), {})
    targets = optional(map(object({
      target_id         = string
      port              = optional(number)
      availability_zone = optional(string)
    })), {})
  }))
  description = "Map of target groups keyed by logical target group name."

  validation {
    condition = alltrue([
      for target_group in values(var.target_groups) : contains(["TCP", "TLS", "UDP", "TCP_UDP"], upper(target_group.protocol))
    ])
    error_message = "Target group protocol must be one of TCP, TLS, UDP, or TCP_UDP."
  }

  validation {
    condition = alltrue([
      for target_group in values(var.target_groups) : contains(["ip", "instance", "alb"], lower(target_group.target_type))
    ])
    error_message = "target_type must be one of ip, instance, or alb."
  }

  validation {
    condition = alltrue([
      for target_group in values(var.target_groups) : !(target_group.name != null && target_group.name_prefix != null)
    ])
    error_message = "Use either target group name or name_prefix, not both."
  }
}

variable "create_security_group" {
  type        = bool
  default     = true
  description = "Whether to create and attach a module-managed security group to the Network Load Balancer."
}

variable "security_group_name" {
  type        = string
  default     = null
  description = "Name for the module-managed security group. Defaults to name."
}

variable "security_group_use_name_prefix" {
  type        = bool
  default     = false
  description = "Whether security_group_name is used as a name prefix."
}

variable "security_group_description" {
  type        = string
  default     = null
  description = "Description for the module-managed security group."
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Existing security group IDs to attach to the Network Load Balancer."
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "IPv4 CIDR blocks allowed to reach listener ports on the module-managed security group."

  validation {
    condition = alltrue([
      for cidr in var.allowed_cidr_blocks : can(cidrnetmask(cidr))
    ])
    error_message = "allowed_cidr_blocks must contain valid IPv4 CIDR blocks."
  }
}

variable "allowed_ipv6_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "IPv6 CIDR blocks allowed to reach listener ports on the module-managed security group."

  validation {
    condition = alltrue([
      for cidr in var.allowed_ipv6_cidr_blocks : can(cidrhost(cidr, 0))
    ])
    error_message = "allowed_ipv6_cidr_blocks must contain valid IPv6 CIDR blocks."
  }
}

variable "egress_cidr_blocks" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "IPv4 CIDR blocks allowed for outbound traffic from the module-managed security group."
}

variable "egress_ipv6_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "IPv6 CIDR blocks allowed for outbound traffic from the module-managed security group."
}

variable "alarms" {
  type = object({
    enabled                   = optional(bool, false)
    alarm_actions             = optional(list(string), [])
    ok_actions                = optional(list(string), [])
    insufficient_data_actions = optional(list(string), [])
    name_prefix               = optional(string, "")
    threshold                 = optional(number, 0)
    comparison_operator       = optional(string, "GreaterThanThreshold")
    evaluation_periods        = optional(number, 1)
    datapoints_to_alarm       = optional(number)
    period                    = optional(number, 60)
    statistic                 = optional(string, "Maximum")
    treat_missing_data        = optional(string, "notBreaching")
  })
  default = {
    enabled = false
  }
  description = "Target-health CloudWatch alarm configuration. Alarm actions are caller-owned."

  validation {
    condition     = var.alarms.enabled == false || length(var.alarms.alarm_actions) > 0
    error_message = "alarms.alarm_actions must contain at least one action ARN when alarms are enabled."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to supported resources."
}
