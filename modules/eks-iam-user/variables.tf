variable "name" {
  type = string
}

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

variable "aws_account_id" {
  type    = string
  default = "1658511"
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
