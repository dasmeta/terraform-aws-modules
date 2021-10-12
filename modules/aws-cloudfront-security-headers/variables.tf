variable "tags" {
  default     = {}
  type        = map(string)
  description = "Tags to add to resouces created by this module"
}

variable "name" {
  type        = string
  description = "Name to use for resource names created by this module"
  default = "CloudFront-Add-HSTS-Header"
}

variable "description" {
  type        = string
  description = "Description to use for resource description created by this module"
  default     = "Adds security headers for Cloudfront"
}

variable "timeout" {
  type        = number
  default     = 1
  description = "Timeout to use for Lambda, defaults to 1ms"
}

variable "memory_size" {
  type        = number
  default     = 128
  description = "Memory to use for Lambda, defaults to 128mb"
}
