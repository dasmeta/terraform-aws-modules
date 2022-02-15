resource "mongodbatlas_auditing" "audit" {
  count = var.enable_auditing ? 1 : 0

  project_id                  = mongodbatlas_project.main.id
  audit_filter                = jsonencode(var.audit_filter)
  audit_authorization_success = false
  enabled                     = true
}
