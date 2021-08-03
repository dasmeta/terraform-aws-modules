output cluster_connection_string {
  value       = mongodbatlas_cluster.main.connection_strings[0].standard
  sensitive   = false
  description = "Mongodb connecton string"
}

output "users" {
  value = {
    for k, p in mongodbatlas_database_user.test :  p.username => nonsensitive(random_password.password[k].result)
  }
  sensitive = false
}
