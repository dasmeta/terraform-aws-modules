variable "cluster" {
  type = object({
    host        = string
    certificate = string
    token       = string
  })
}

variable "namespace" {
  type        = string
  description = "The namespace of kubernetes resources"
  default     = "kube-system"
}
