resource "aws_codecommit_repository" "this" {
  count = var.create ? 1 : 0

  repository_name = var.repository_name
  description     = var.description
  default_branch  = var.default_branch
  kms_key_id      = var.kms_key_id
  tags            = var.tags
}
