resource "random_password" "password" {
  length           = 16
  special          = false
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [aws_security_group.sg.id]

  monitoring_interval = "30"
  monitoring_role_name = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  subnet_ids = var.subnet_ids

  identifier = var.name

  create_db_option_group    = false
  create_db_parameter_group = false

  engine               = "postgres"
  engine_version       = var.engine_version
  family               = "postgres11"
  major_engine_version = "11"
  instance_class       = var.instance_class

  allocated_storage = var.storage

  name     = var.database
  username = var.username
  create_random_password = false
  password = var.password == "" ? random_password.password.result : var.password
  port     = 5432

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = var.backup_retention_period
  deletion_protection = true
}