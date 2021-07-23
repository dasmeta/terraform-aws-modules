output cluster_connection_string {
  value       = mongodbatlas_cluster.main.connection_strings[0].standard
  sensitive   = false
  description = "Mongodb connecton string"
}
