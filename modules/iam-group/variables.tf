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

variable "attach_users_to_group" {
  type        = bool
  default     = true
  description = "Attach Users in Group"
}

variable "police_action" {
  type    = list(any)
  default = []
}
