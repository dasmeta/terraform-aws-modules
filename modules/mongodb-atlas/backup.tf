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

resource "mongodbatlas_cloud_provider_snapshot_backup_policy" "backup" {
  count = var.use_cloud_provider_snapshot_backup_policy ? 1 : 0

  cluster_name             = "von-poll-production"
  project_id               = "60f4858701216b7daa451896"
  reference_hour_of_day    = 11
  reference_minute_of_hour = 10
  restore_window_days      = 4
  update_snapshots         = false

  policies {
    id = "60f48c80c65bed025f2b1e25"

    policy_item {
      frequency_interval = 1
      frequency_type     = "hourly"
      id                 = "60f48c80c65bed025f2b1e26"
      retention_unit     = "days"
      retention_value    = 1
    }
    policy_item {
      frequency_interval = 1
      frequency_type     = "daily"
      id                 = "60f48c80c65bed025f2b1e27"
      retention_unit     = "days"
      retention_value    = 2
    }
    policy_item {
      frequency_interval = 4
      frequency_type     = "weekly"
      id                 = "60f48c80c65bed025f2b1e28"
      retention_unit     = "weeks"
      retention_value    = 3
    }
    policy_item {
      frequency_interval = 5
      frequency_type     = "monthly"
      id                 = "60f48c80c65bed025f2b1e29"
      retention_unit     = "months"
      retention_value    = 4
    }
  }
}
