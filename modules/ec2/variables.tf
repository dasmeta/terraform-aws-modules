variable "name" {
  type        = string
  description = "EC2 Instance name"
}

variable "alarms" {
  type = object({
    enabled       = optional(bool, true)
    sns_topic     = string
    custom_values = optional(any, {})
  })

  description = "Alarms for EC2"
}
