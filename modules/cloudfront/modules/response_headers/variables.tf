variable "custom_headers" {
  type = list(object({
    header   = string
    value    = string
    override = bool
  }))
  description = "List of custom headers with header name, value, and override flag"
  default     = []
}

variable "security_headers" {
  type = object({
    frame_options = optional(string)
  })
  default = {}
}

variable "name" {
  type        = string
  description = "Cloudfront response headers polic"
}
