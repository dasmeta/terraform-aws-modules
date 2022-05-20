variable "name" {
  type    = string
  default = "ReadOnlyGroup"
}

variable "users" {
  type    = list(string)
  default = []
}

variable "type" {
  type        = string
  default     = "read-only"
  description = "You can set read-only or admin-access or set other and set your own police action"
}

variable "policy_action" {
  type    = list(any)
  default = []
}
