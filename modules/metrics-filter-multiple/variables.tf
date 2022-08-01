variable "metrics_namespace" {
  type    = string
  default = "LogBasedMetrics"
}

variable "patterns" {
  type = list(any)
  default = [
    # {
    #   name       = ""
    #   source     = ""
    #   pattern    = ""
    #   dimensions = {}
    # }
  ]
}

variable "log_groups" {
  type = map(any)
  default = {
    # group1 = ""
    # group2 = ""
    # groupN = ""
  }
}
