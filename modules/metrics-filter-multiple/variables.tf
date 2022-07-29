variable "metrics_namespace" {
  type    = string
  default = "LogBasedMetrics"
}

variable "patterns" {
  type = list(any)
  default = [
    {
      name       = "errors"
      source     = "group1"
      pattern    = "error"
      dimensions = {}
    }
  ]
}

variable "log_groups" {
  type = map(any)
  default = {
    group1 = "/group/one/path"
    group2 = "/group/two/path"
    groupN = "/group/nnn/path"
  }
}
