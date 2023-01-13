variable "name" {
  type        = string
  description = "Application name"
}

variable "description" {
  type        = string
  description = "Application description"
  default     = ""
}

variable "configs" {
  type = list(object({
    name         = string
    content_type = optional(string, "application/json")
    version      = optional(string, "1")
    content      = optional(string, null) # in case some specific content needs to be set you can use this field instead of flags, but usually the flags should be used
    flags = optional(list(object({
      name               = string
      enabled            = optional(bool, false)
      deprecation_status = optional(string, null)
      attributes = optional(list(object({
        name     = string
        type     = optional(string, "string")
        required = optional(bool, true)
        value    = optional(string, "")
      })), [])
    })), [])
    description  = optional(string, "")
    location_uri = optional(string, "hosted")
    type         = optional(string, "AWS.AppConfig.FeatureFlags")
    validators = optional(list(object({
      type    = optional(string, "JSON_SCHEMA")
      content = optional(string, null)
    })), [])
  }))
  description = "List of configuration profiles/flags"
  default     = []
}

variable "environments" {
  type = list(object({
    name                           = string # the name should be unique
    description                    = optional(string, null)
    deployment_duration_in_minutes = optional(number, 3)
    deploys = optional(list(object({
      config   = string
      strategy = optional(string, "AppConfig.AllAtOnce")
      version  = optional(string, "1")
    })), [])
    monitors = optional(list(object({
      alarm_arn      = string
      alarm_role_arn = string
    })), [])
  }))
  description = "List of environments with configs"
  default     = []
}

variable "deployment_strategies" {
  type = list(object({
    name                           = string # the name should be unique
    description                    = optional(string, null)
    deployment_duration_in_minutes = optional(number, 3)
    final_bake_time_in_minutes     = optional(number, 4)
    growth_factor                  = optional(number, 10)
    growth_type                    = optional(string, "LINEAR")
    replicate_to                   = optional(string, "NONE")
  }))
  description = "List of deployment strategies with configs"
  default     = []
}
