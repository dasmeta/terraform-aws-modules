
resource "mongodbatlas_cloud_provider_snapshot_backup_policy" "backup" {
  project_id   = mongodbatlas_cluster.main.project_id
  cluster_name = mongodbatlas_cluster.main.name

  reference_hour_of_day    = 11
  reference_minute_of_hour = 10
  restore_window_days      = 4

  policies {
    id = mongodbatlas_cluster.main.snapshot_backup_policy.0.policies.0.id
    policy_item {
      id                 = mongodbatlas_cluster.main.snapshot_backup_policy.0.policies.0.policy_item.0.id
      frequency_interval = 1
      frequency_type     = "hourly"
      retention_unit     = "days"
      retention_value    = 1
    }
    policy_item {
      id                 = mongodbatlas_cluster.main.snapshot_backup_policy.0.policies.0.policy_item.1.id
      frequency_interval = 1
      frequency_type     = "daily"
      retention_unit     = "days"
      retention_value    = 2
    }
    policy_item {
      id                 = mongodbatlas_cluster.main.snapshot_backup_policy.0.policies.0.policy_item.2.id
      frequency_interval = 4
      frequency_type     = "weekly"
      retention_unit     = "weeks"
      retention_value    = 3
    }
    policy_item {
      id                 = mongodbatlas_cluster.main.snapshot_backup_policy.0.policies.0.policy_item.3.id
      frequency_interval = 5
      frequency_type     = "monthly"
      retention_unit     = "months"
      retention_value    = 4
    }
  }
}

data "mongodbatlas_cloud_provider_snapshot_backup_policy" "backup" {
  project_id   = mongodbatlas_cloud_provider_snapshot_backup_policy.backup.project_id
  cluster_name = mongodbatlas_cloud_provider_snapshot_backup_policy.backup.cluster_name
}
