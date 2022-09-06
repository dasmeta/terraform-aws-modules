variable "resource_group" {
  type = string
}

variable "aks_cluster_name" {
  type = string
}

variable "admin_group_name" {
  type = string
}

variable "assignment" {
  type = list(object({
    group = string
    namespace = string
    name = string

    role = list(object({
      actions    = list(string)
      resources = list(string)

    }))
  }))
}
