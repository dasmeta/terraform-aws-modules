resource "mongodbatlas_cluster" "main" {
  project_id   = mongodbatlas_project.main.id
  name         = var.project_name
  cluster_type = var.cluster_configs.cluster_type
  replication_specs {
    num_shards = var.cluster_configs.replication_specs.num_shards
    regions_config {
      region_name     = var.cluster_configs.replication_specs.region_name
      electable_nodes = var.cluster_configs.replication_specs.electable_nodes
      priority        = var.cluster_configs.replication_specs.priority
      read_only_nodes = var.cluster_configs.replication_specs.read_only_nodes
    }
  }
  cloud_backup                 = var.cloud_backup
  auto_scaling_disk_gb_enabled = var.cluster_configs.auto_scaling_disk_gb_enabled
  mongo_db_major_version       = var.cluster_configs.mongo_db_major_version

  //Provider Settings "block"
  provider_name               = var.cluster_configs.provider_name
  disk_size_gb                = var.cluster_configs.disk_size_gb
  provider_instance_size_name = var.cluster_configs.provider_instance_size_name
  # provider_backup_enabled     = var.provider_backup_enabled
}
