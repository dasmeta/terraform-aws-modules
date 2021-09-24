resource "aws_mq_broker" "mq" {
  broker_name         = var.broker_name

  engine_type         = var.engine_type
  engine_version      = var.engine_version
  storage_type        = var.storage_type

  # the most cheap type is mq.m5.large on multi az deployment mode, mq.t3.micro is available on SINGLE_INSTANCE deployment mode.
  host_instance_type  = var.host_instance_type
  deployment_mode     = var.deployment_mode
  publicly_accessible = var.publicly_accessible
  subnet_ids          = var.subnet_ids
  security_groups     = var.security_groups

  auto_minor_version_upgrade = var.auto_minor_version_upgrade

  # logs {
  #   general = var.enable_cloudwatch_logs
  #   audit = false
  # }

  maintenance_window_start_time {
    day_of_week = var.mw_day_of_week
    time_of_day = var.mw_time_of_day
    time_zone   = var.mw_time_zone
  }

  user {
    username = var.username
    password = var.password
  }

  tags = var.tags
}
