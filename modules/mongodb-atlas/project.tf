resource "mongodbatlas_project" "main" {
  name                         = var.project_name
  org_id                       = var.org_id
  with_default_alerts_settings = var.with_default_alerts_settings

  teams {
    role_names = var.team_roles
    team_id    = var.team_id
  }
}
