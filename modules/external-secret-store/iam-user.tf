module "iam-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "4.6.0"

  name  = "${local.sanitized-name}-secret-manager"
  count = var.create_user ? 1 : 0

  create_iam_access_key         = true
  create_user                   = true
  create_iam_user_login_profile = false
  upload_iam_user_ssh_key       = false
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = module.iam-user[0].iam_user_name
  policy_arn = aws_iam_policy.policy.arn

  depends_on = [
    module.iam-user
  ]
}
