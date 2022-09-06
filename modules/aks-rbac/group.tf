data "azuread_group" "example" {
  display_name     = var.admin_group_name
  security_enabled = true
}
