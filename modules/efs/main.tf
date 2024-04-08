data "aws_region" "current" {}
data "aws_vpc" "selected" {
  count = var.vpc_id != "" ? 1 : 0

  id = var.vpc_id
}

locals {
  az_name = var.availability_zone_prefix != "" ? format("%s%s", data.aws_region.current.name, var.availability_zone_prefix) : null
}

resource "aws_efs_file_system" "efs" {
  creation_token                  = var.creation_token
  availability_zone_name          = local.az_name
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_id
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode

  dynamic "lifecycle_policy" {
    for_each = [for k, v in var.lifecycle_policy : { (k) = v }]

    content {
      transition_to_ia                    = try(lifecycle_policy.value.transition_to_ia, null)
      transition_to_archive               = try(lifecycle_policy.value.transition_to_archive, null)
      transition_to_primary_storage_class = try(lifecycle_policy.value.transition_to_primary_storage_class, null)
    }
  }

  tags = merge({
    Name = var.name
  }, var.tags)
}

resource "aws_efs_mount_target" "mount_target" {
  for_each = toset(var.mount_target_subnets)

  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs_kube_sg[0].id]
}

resource "aws_security_group" "efs_kube_sg" {
  count = var.vpc_id != "" ? 1 : 0

  name        = "EFS to ${var.vpc_id} VPC"
  description = "Allow EFS traffic to VPC"
  vpc_id      = data.aws_vpc.selected[0].id

  ingress {
    description = "EFS to VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected[0].cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "efs-to-vpc"
  }
}
