module "ecr" {
  source  = "cloudposse/ecr/aws"
  version = "0.35.0"

  for_each = { for repo in var.repos : repo => repo }

  name            = each.value
  max_image_count = var.max_image_count
  protected_tags  = var.protected_tags
}
