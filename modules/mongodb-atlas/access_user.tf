resource "mongodbatlas_org_invitation" "org_invitation" {
  for_each = var.org_invitation_enabled ? { for user in var.access_users : user.username => user } : {}
  username = each.value.username
  org_id   = var.org_id
  roles    = each.value.roles
}

resource "mongodbatlas_project_invitation" "project_invitation" {
  for_each   = { for user in var.access_users : user.username => user }
  username   = each.value.username
  project_id = mongodbatlas_project.main.id
  roles      = each.value.project_roles
}
