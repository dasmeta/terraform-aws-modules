variable "name" {
  type        = string
  description = "Function name"
}

variable "comment" {
  type        = string
  description = "Function comment"
  default     = ""
}

variable "runtime" {
  type        = string
  description = "Function runtime"
  default     = "cloudfront-js-1.0"
}

variable "publish" {
  type        = bool
  description = "Function Publish"
  default     = true
}

variable "code" {
  type        = any
  description = "Function code"
}
