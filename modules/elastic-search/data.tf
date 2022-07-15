data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_subnet" "selected" {
  count = length(var.vpc_options_subnet_ids) > 0 ? 1 : 0

  id = var.vpc_options_subnet_ids[0]
}
