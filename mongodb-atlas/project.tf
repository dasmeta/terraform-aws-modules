resource "mongodbatlas_project" "main" {
  name   = var.project_name
  org_id = var.org_id

  # teams {
  #   team_id    = "5e0fa8c99ccf641c722fe645"
  #   role_names = ["GROUP_OWNER"]
  # }

  # teams {
  #   team_id    = "5e1dd7b4f2a30ba80a70cd4rw"
  #   role_names = ["GROUP_READ_ONLY", "GROUP_DATA_ACCESS_READ_WRITE"]
  # }
}
