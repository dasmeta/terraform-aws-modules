data "aws_region" "current" {}

resource "aws_efs_file_system" "efs" {
  creation_token                  = var.creation_token
  availability_zone_name          = local.az_name
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_id
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode
  tags                            = var.tags
}

resource "aws_efs_mount_target" "mount_target" {
  for_each       = toset(var.mount_target_subnets)
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = each.value
}

locals {
  az_name = var.availability_zone_prefix != "" ? format("%s%s", data.aws_region.current.name, var.availability_zone_prefix) : null
}
