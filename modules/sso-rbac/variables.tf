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

variable "eks_module" {
  type = any
}
