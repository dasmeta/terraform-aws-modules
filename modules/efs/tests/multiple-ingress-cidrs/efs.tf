module "this" {
  source = "../.."
  # version = "2.14.1"

  creation_token       = "EFS-test"
  mount_target_subnets = ["sub-xxx", "sub-yyy", "sub-zzz"]
  name                 = "test-efs"
  vpc_id               = "vpc-1213131313131"
  ingress_with_cidr_blocks = [
    {
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      description = "Home network"
      cidr_blocks = "10.0.1.0/24"
    },
    {
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      description = "Work network"
      cidr_blocks = "10.2.1.0/24"
    },
  ]
}
