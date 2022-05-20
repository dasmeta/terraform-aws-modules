variable "namespace" {
  type = string
}

variable "usernames" {
  type = list(string)
}

variable "create_namespace" {
  type    = bool
  default = true
}

variable "rule" {
  type = list(any)
  default = [
    {
      api_groups = ["", "apps"]
      resources  = ["pods", "pods/log", "configmaps", "services", "endpoints", "crontabs", "deployments", "nodes"]
      verbs      = ["*"]
    },
    {
      api_groups = ["extensions"]
      resources  = ["pods", "pods/log", "configmaps", "services", "endpoints", "crontabs", "deployments", "nodes"]
      verbs      = ["*"]
    }
  ]
}
