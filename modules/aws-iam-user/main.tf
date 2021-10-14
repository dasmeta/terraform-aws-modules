module "iam_user" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-user"
    version = "4.6.0"
    name                          = var.username
    create_user                   = var.create_user
    create_iam_user_login_profile = var.console
    create_iam_access_key         = var.api
    pgp_key                       = var.pgp_key
}

resource "aws_iam_policy_attachment" "user-attach" {
  for_each      = toset( var.policy_attachment )
  name          = "attach-${var.username}"
  users         = [var.username]
  policy_arn    = each.key
  depends_on    = [
      module.iam_user
    ]

  lifecycle {
    ignore_changes = [
      users,
    ]
  }
}

resource "aws_iam_user_policy" "iam_user_policy" {
  count         = var.policy != null ?  1 : 0
  name          = "policy-${var.username}"
  user          = var.username
  depends_on    = [ module.iam_user ]
  policy        = var.policy
}
