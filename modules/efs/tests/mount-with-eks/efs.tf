module "efs" {
  source               = "../../"
  creation_token       = "EFS-test"
  mount_target_subnets = ["sub-xxx", "sub-yyy", "sub-zzz"]
  vpc_id               = "vpc-1213131313131"
}
