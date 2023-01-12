data "aws_vpcs" "all" {
  tags = {
    Name = "default"
  }
}
data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.all.ids[0]]
  }
}
data "aws_vpc" "default" {
  id = data.aws_vpcs.all.ids[0]
}
