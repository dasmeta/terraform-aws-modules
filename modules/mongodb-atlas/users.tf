resource "random_password" "password" {
  for_each = toset(var.users)

  length           = 16
  special          = true
  override_special = "_$%"
}

resource "mongodbatlas_database_user" "user" {
  for_each = toset(var.users)

  username           = each.value
  password           = random_password.password[each.key].result
  auth_database_name = "admin"
  project_id         = mongodbatlas_project.main.id

  roles {
    role_name     = "readWrite"
    database_name = "development"
  }
  scopes {
    name = var.project_name
    type = "CLUSTER"
  }

  lifecycle {
    ignore_changes = [password]
  }
}
