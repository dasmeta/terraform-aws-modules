variable "name" {
  type    = string
  default = "ReadOnlyGroup"
}

variable "users" {
  type    = list(string)
  default = []
}


variable "attach_users_to_group" {
  type        = bool
  default     = true
  description = "Attach Users to Group"
}
