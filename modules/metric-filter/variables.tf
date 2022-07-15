variable "metrics_patterns" {
  type = any
  default = [
    {
      name    = "ERROR"
      pattern = "ERROR"
      unit    = "None"
    }
  ]
}

variable "log_group_name" {
  type = string
}

variable "metrics_namespace" {
  type    = string
  default = "Log_Filters"
}

variable "dimensions" {
  type    = any
  default = {}
}
