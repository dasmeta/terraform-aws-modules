variable "name" {
  type = string
}

variable "database" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
  default = ""
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}
