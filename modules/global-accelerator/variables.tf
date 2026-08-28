variable "name" {
  type        = string
  description = "Name of the Global Accelerator."

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "name must contain from 1 through 64 characters."
  }

  validation {
    condition     = can(regex("^[0-9A-Za-z]([0-9A-Za-z-]*[0-9A-Za-z])?$", var.name))
    error_message = "name must contain only alphanumeric characters and hyphens and must not begin or end with a hyphen."
  }
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether the accelerator accepts and routes traffic."
}

variable "ip_address_type" {
  type        = string
  default     = "IPV4"
  description = "IP address type for the accelerator."

  validation {
    condition     = contains(["IPV4", "DUAL_STACK"], var.ip_address_type)
    error_message = "ip_address_type must be either IPV4 or DUAL_STACK."
  }
}

variable "listeners" {
  type = map(object({
    protocol        = optional(string, "TCP")
    client_affinity = optional(string, "NONE")
    port_ranges = list(object({
      from_port = number
      to_port   = number
    }))
    endpoint_groups = map(object({
      endpoint_group_region   = string
      traffic_dial_percentage = optional(number, 100)
      health_check = optional(object({
        protocol         = optional(string, "TCP")
        port             = optional(number)
        path             = optional(string)
        interval_seconds = optional(number, 30)
        threshold_count  = optional(number, 3)
      }), {})
      endpoints = list(object({
        endpoint_id                    = string
        weight                         = optional(number, 128)
        client_ip_preservation_enabled = optional(bool)
      }))
      port_overrides = optional(list(object({
        listener_port = number
        endpoint_port = number
      })), [])
    }))
  }))
  description = "Map of listeners and regional endpoint groups keyed by stable logical names."

  validation {
    condition     = length(var.listeners) >= 1
    error_message = "listeners must contain at least one listener."
  }

  validation {
    condition = alltrue([
      for listener_key, listener in var.listeners :
      can(regex("^[A-Za-z0-9][A-Za-z0-9_-]*$", listener_key)) &&
      alltrue([
        for group_key in keys(listener.endpoint_groups) :
        can(regex("^[A-Za-z0-9][A-Za-z0-9_-]*$", group_key))
      ])
    ])
    error_message = "Listener and endpoint-group keys must begin with an alphanumeric character and contain only alphanumeric characters, underscores, and hyphens."
  }

  validation {
    condition = alltrue([
      for listener in values(var.listeners) :
      length(listener.port_ranges) >= 1 && length(listener.port_ranges) <= 10
    ])
    error_message = "Each listener must contain from 1 through 10 port ranges."
  }

  validation {
    condition = alltrue([
      for listener in values(var.listeners) : length(listener.endpoint_groups) >= 1
    ])
    error_message = "Each listener must contain at least one endpoint group."
  }

  validation {
    condition = alltrue([
      for listener in values(var.listeners) : contains(["TCP", "UDP"], listener.protocol)
    ])
    error_message = "Listener protocol must be either TCP or UDP."
  }

  validation {
    condition = alltrue([
      for listener in values(var.listeners) : contains(["NONE", "SOURCE_IP"], listener.client_affinity)
    ])
    error_message = "Listener client_affinity must be either NONE or SOURCE_IP."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for port_range in listener.port_ranges :
        port_range.from_port >= 1 &&
        port_range.from_port <= 65535 &&
        floor(port_range.from_port) == port_range.from_port &&
        port_range.to_port >= 1 &&
        port_range.to_port <= 65535 &&
        floor(port_range.to_port) == port_range.to_port
      ]
    ]))
    error_message = "Listener range ports must be integers from 1 through 65535."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for port_range in listener.port_ranges : port_range.from_port <= port_range.to_port
      ]
    ]))
    error_message = "Each listener port range must have from_port less than or equal to to_port."
  }

  validation {
    condition = alltrue(flatten([
      for listener_key, listener in var.listeners : [
        for range_index, port_range in listener.port_ranges : [
          for other_listener_key, other_listener in var.listeners : [
            for other_range_index, other_port_range in other_listener.port_ranges :
            (listener_key == other_listener_key && range_index == other_range_index) ||
            port_range.to_port < other_port_range.from_port ||
            other_port_range.to_port < port_range.from_port
          ]
        ]
      ]
    ]))
    error_message = "Listener port ranges must not overlap anywhere on the accelerator."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) : length(trimspace(group.endpoint_group_region)) >= 1
      ]
    ]))
    error_message = "Each endpoint_group_region must be non-empty after trimming whitespace."
  }

  validation {
    condition = alltrue([
      for listener in values(var.listeners) :
      length(distinct([
        for group in values(listener.endpoint_groups) : group.endpoint_group_region
      ])) == length(listener.endpoint_groups)
    ])
    error_message = "Endpoint-group Regions must be unique within each listener."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) :
        length(group.endpoints) >= 1 && length(group.endpoints) <= 10
      ]
    ]))
    error_message = "Each endpoint group must contain from 1 through 10 endpoints."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) : [
          for endpoint in group.endpoints :
          length(trimspace(endpoint.endpoint_id)) >= 1 &&
          length(trimspace(endpoint.endpoint_id)) <= 255
        ]
      ]
    ]))
    error_message = "Each endpoint_id must contain from 1 through 255 characters after trimming whitespace."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) : [
          for endpoint in group.endpoints :
          endpoint.weight >= 0 &&
          endpoint.weight <= 255 &&
          floor(endpoint.weight) == endpoint.weight
        ]
      ]
    ]))
    error_message = "Endpoint weights must be integers from 0 through 255."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) :
        group.traffic_dial_percentage >= 0 && group.traffic_dial_percentage <= 100
      ]
    ]))
    error_message = "Endpoint-group traffic_dial_percentage must be from 0 through 100."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) :
        contains(["TCP", "HTTP", "HTTPS"], group.health_check.protocol)
      ]
    ]))
    error_message = "Health-check protocol must be TCP, HTTP, or HTTPS."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) :
        contains([10, 30], group.health_check.interval_seconds)
      ]
    ]))
    error_message = "Health-check interval_seconds must be either 10 or 30."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) :
        group.health_check.port == null ? true : (
          group.health_check.port >= 1 &&
          group.health_check.port <= 65535 &&
          floor(group.health_check.port) == group.health_check.port
        )
      ]
    ]))
    error_message = "Health-check port must be null or an integer from 1 through 65535."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) :
        group.health_check.threshold_count >= 1 &&
        group.health_check.threshold_count <= 10 &&
        floor(group.health_check.threshold_count) == group.health_check.threshold_count
      ]
    ]))
    error_message = "Health-check threshold_count must be an integer from 1 through 10."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) :
        group.health_check.path == null ? true : (
          contains(["HTTP", "HTTPS"], group.health_check.protocol) &&
          length(group.health_check.path) >= 1 &&
          length(group.health_check.path) <= 255 &&
          can(regex("^/[-a-zA-Z0-9@:%_+.~#?&/=]*$", group.health_check.path))
        )
      ]
    ]))
    error_message = "Health-check path must be null for TCP or a 1-to-255-character absolute path using the supported AWS characters for HTTP or HTTPS."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) : length(group.port_overrides) <= 10
      ]
    ]))
    error_message = "Each endpoint group can contain at most 10 port overrides."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) : [
          for override in group.port_overrides :
          override.listener_port >= 1 &&
          override.listener_port <= 65535 &&
          floor(override.listener_port) == override.listener_port &&
          override.endpoint_port >= 1 &&
          override.endpoint_port <= 65535 &&
          floor(override.endpoint_port) == override.endpoint_port
        ]
      ]
    ]))
    error_message = "Port-override listener and endpoint ports must be integers from 1 through 65535."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) : [
          for override in group.port_overrides :
          anytrue([
            for port_range in listener.port_ranges :
            override.listener_port >= port_range.from_port &&
            override.listener_port <= port_range.to_port
          ])
        ]
      ]
    ]))
    error_message = "Each port-override listener_port must belong to its parent listener."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) : [
          for override in group.port_overrides :
          alltrue(flatten([
            for other_listener in values(var.listeners) : [
              for port_range in other_listener.port_ranges :
              override.endpoint_port < port_range.from_port ||
              override.endpoint_port > port_range.to_port
            ]
          ]))
        ]
      ]
    ]))
    error_message = "Each port-override endpoint_port must be outside every listener range on the accelerator."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) :
        length(distinct([
          for override in group.port_overrides : override.listener_port
        ])) == length(group.port_overrides)
      ]
    ]))
    error_message = "Port-override listener_port values must be unique within each endpoint group."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) :
        length(distinct([
          for override in group.port_overrides : override.endpoint_port
        ])) == length(group.port_overrides)
      ]
    ]))
    error_message = "Port-override endpoint_port values must be unique within each endpoint group."
  }

  validation {
    condition = alltrue(flatten([
      for listener in values(var.listeners) : [
        for group in values(listener.endpoint_groups) : [
          for override in group.port_overrides : [
            for other_listener in values(var.listeners) : [
              for other_group in values(other_listener.endpoint_groups) : [
                for other_override in other_group.port_overrides :
                override.endpoint_port != other_override.endpoint_port ||
                override.listener_port == other_override.listener_port
              ]
            ]
          ]
        ]
      ]
    ]))
    error_message = "The same endpoint_port cannot map from different listener_port values anywhere on the accelerator."
  }
}

variable "flow_logs" {
  type = object({
    enabled   = optional(bool, false)
    s3_bucket = optional(string)
    s3_prefix = optional(string)
  })
  default = {
    enabled = false
  }
  description = "Optional Global Accelerator flow-log delivery configuration for an existing S3 bucket."

  validation {
    condition = !var.flow_logs.enabled || (
      try(length(trimspace(var.flow_logs.s3_bucket)) >= 1, false) &&
      try(length(var.flow_logs.s3_bucket) <= 255, false) &&
      try(length(trimspace(var.flow_logs.s3_prefix)) >= 1, false) &&
      try(length(var.flow_logs.s3_prefix) <= 255, false)
    )
    error_message = "Enabled flow logs require non-empty s3_bucket and s3_prefix values no longer than 255 characters."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to supported Global Accelerator resources."
}
