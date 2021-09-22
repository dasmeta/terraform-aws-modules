module "iam_iam-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "4.6.0"

  name = var.name
  enabled = var.create_user && !var.aws_access_key_id
  create_iam_access_key = true
  create_user = false
}
