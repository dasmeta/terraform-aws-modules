output "endpoint" {
  value = module.db.this_db_instance_endpoint
}

output "password" {
  value     = module.db.this_db_master_password
  sensitive = true
}
