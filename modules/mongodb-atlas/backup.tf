resource "mongodbatlas_cloud_backup_schedule" "backup" {
  project_id   = mongodbatlas_cluster.main.project_id
  cluster_name = mongodbatlas_cluster.main.name

  reference_hour_of_day    = 11
  reference_minute_of_hour = 10
  restore_window_days      = 4

  policy_item_hourly {
    frequency_interval = 1
    retention_unit     = "days"
    retention_value    = 1
  }
  policy_item_daily {
    frequency_interval = 1
    retention_unit     = "days"
    retention_value    = 2
  }
  policy_item_weekly {
    frequency_interval = 4
    retention_unit     = "weeks"
    retention_value    = 3
  }
  policy_item_monthly {
    frequency_interval = 5
    retention_unit     = "months"
    retention_value    = 4
  }
}

data "mongodbatlas_cloud_backup_schedule" "backup" {
  project_id   = mongodbatlas_cloud_backup_schedule.backup.project_id
  cluster_name = mongodbatlas_cloud_backup_schedule.backup.cluster_name
}
