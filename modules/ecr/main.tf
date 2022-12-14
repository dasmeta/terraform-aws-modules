module "ecr" {
  source  = "cloudposse/ecr/aws"
  version = "0.35.0"

  for_each = { for repo in var.repos : repo => repo }

  name = each.value
}
