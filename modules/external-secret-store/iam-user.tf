module "iam-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "4.6.0"

  name = var.name
  count = var.create_user ? 1 : 0
  create_iam_access_key = true
  create_user = false
}
