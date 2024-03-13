module "efs" {
  source               = "dasmeta/modules/aws//modules/efs"
  encrypted            = true
  kms_key_id           = aws_kms_key.key.arn
  performance_mode     = "generalPurpose"
  throughput_mode      = "bursting"
  mount_target_subnets = ["sub-xxx", "sub-yyy", "sub-zzz"]
}

resource "aws_kms_key" "key" {
  description             = "kms-key"
  deletion_window_in_days = 10
}
