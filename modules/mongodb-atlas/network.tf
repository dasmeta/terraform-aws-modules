resource "mongodbatlas_project_ip_access_list" "ip-access-list" {
  for_each = toset(var.ip_addresses)

  project_id = mongodbatlas_project.main.id
  ip_address = each.value
  comment    = "ip address range items"
}
