resource "mongodbatlas_cloud_backup_schedule" "backup" {
  count = var.use_cloud_backup_schedule ? 1 : 0

  project_id   = mongodbatlas_cluster.main.project_id
  cluster_name = mongodbatlas_cluster.main.name

  reference_hour_of_day    = 11
  reference_minute_of_hour = 10
  restore_window_days      = var.schedule_restore_window_days

  dynamic "policy_item_hourly" {
    for_each = var.policy_item_hourly.retention_unit != "" ? [1] : []

    content {
      frequency_interval = var.policy_item_hourly.frequency_interval
      retention_unit     = var.policy_item_hourly.retention_unit
      retention_value    = var.policy_item_hourly.retention_value
    }
  }

  dynamic "policy_item_daily" {
    for_each = var.policy_item_daily.retention_unit != "" ? [1] : []

    content {
      frequency_interval = var.policy_item_daily.frequency_interval
      retention_unit     = var.policy_item_daily.retention_unit
      retention_value    = var.policy_item_daily.retention_value
    }
  }

  dynamic "policy_item_weekly" {
    for_each = var.policy_item_weekly.retention_unit != "" ? [1] : []

    content {
      frequency_interval = var.policy_item_weekly.frequency_interval
      retention_unit     = var.policy_item_weekly.retention_unit
      retention_value    = var.policy_item_weekly.retention_value
    }
  }

  dynamic "policy_item_monthly" {
    for_each = var.policy_item_monthly.retention_unit != "" ? [1] : []

    content {
      frequency_interval = var.policy_item_monthly.frequency_interval
      retention_unit     = var.policy_item_monthly.retention_unit
      retention_value    = var.policy_item_monthly.retention_value
    }
  }
}