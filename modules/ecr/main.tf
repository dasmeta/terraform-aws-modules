module "ecr" {
  source = "git::https://github.com/dasmeta/terraform-aws-ecr.git?ref=main"
  # TODO: we module with direct github repo source because there was need some ability, please check PR: https://github.com/cloudposse/terraform-aws-ecr/issues/133 and uncomment source to tf registry
  # source  = "cloudposse/ecr/aws"
  # version = "0.41.1"

  for_each = { for repo in var.repos : repo => repo }

  name                       = each.value
  max_image_count            = var.max_image_count
  protected_tags             = var.protected_tags
  image_tag_mutability       = var.image_tag_mutability
  principals_readonly_access = var.principals_readonly_access
}
