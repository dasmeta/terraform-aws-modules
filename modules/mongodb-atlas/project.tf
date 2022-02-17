resource "mongodbatlas_project" "main" {
  name                         = var.project_name
  org_id                       = var.org_id
  with_default_alerts_settings = var.with_default_alerts_settings

  dynamic "teams" {
    for_each = { for team in var.teams : team.team_id => team }

    content {
      team_id    = teams.value.team_id
      role_names = teams.value.role_names
    }
  }
}
