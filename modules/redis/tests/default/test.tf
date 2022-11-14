module "redis" {
  source = "../../"

  vpc_id = "vpc-08c236e492159e0d4"
  # availability_zones = [""]
  allowed_security_group_ids = ["sg-0b71bdf038cfd6313"]
  subnets                    = ["subnet-010b9df2192cf206c", "subnet-0a1993e69c2ba65d4"]
  engine_version             = "7.0"
  family                     = "redis7"
  name                       = "test"
}
