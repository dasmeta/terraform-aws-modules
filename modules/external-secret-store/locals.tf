locals {
  sanitized-name = replace(var.name, "/", "-")
}
