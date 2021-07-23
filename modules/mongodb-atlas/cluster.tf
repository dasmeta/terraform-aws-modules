resource "mongodbatlas_cluster" "main" {
  project_id   = mongodbatlas_project.main.id
  name         = var.project_name
  cluster_type = "REPLICASET"
  replication_specs {
    num_shards = 1
    regions_config {
      region_name     = "EU_CENTRAL_1"
      electable_nodes = 3
      priority        = 7
      read_only_nodes = 0
    }
  }
  provider_backup_enabled      = true
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "4.2"

  //Provider Settings "block"
  provider_name               = "AWS"
  disk_size_gb                = 100
  provider_instance_size_name = "M10"
}
