variable "function_name" {
  type    = string
  default = ""
}

variable "bucket_name" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "memory_size" {
  description = "Memory size for Lambda function"
  type        = number
  default     = null
}

variable "timeout" {
  description = "Timeout for Lambda function"
  type        = number
  default     = null
}

variable "create_alarm" {
  type    = bool
  default = false
}

# variable "alarm_actions" {
#   type    = list(string)
#   default = []
# }

# variable "ok_actions" {
#   type    = list(string)
#   default = []
# }
