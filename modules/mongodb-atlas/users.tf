resource "random_password" "password" {
  for_each = { for user in var.users : user.username => user }

  length           = 16
  special          = true
  override_special = "_$%"
}

resource "mongodbatlas_database_user" "user" {
  for_each = { for user in var.users : user.username => user }

  username           = each.value.username
  password           = random_password.password[each.key].result
  auth_database_name = "admin"
  project_id         = mongodbatlas_project.main.id

  dynamic "roles" {
    for_each = each.value.roles

    content {
      role_name     = each.value.roles.role_name
      database_name = each.value.roles.database_name
    }

  }
  dynamic "scopes" {
    for_each = each.value.scopes

    content {
      name = each.value.scopes.name
      type = each.value.scopes.type
    }
  }

  lifecycle {
    ignore_changes = [password]
  }
}
