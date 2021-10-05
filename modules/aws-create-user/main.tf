module "iam_user" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-user"
    version = "4.6.0"
    name                          = var.user-name
    create_user                   = true
    create_iam_user_login_profile = true
    create_iam_access_key         = true
    pgp_key                       = ""
}

resource "aws_iam_policy_attachment" "user-attach" {
  for_each      = toset( var.policy-arn )
  name          = "user-attach"
  users         = [var.user-name]
  policy_arn    = each.key
  depends_on    = [
      module.iam_user
    ]
}

resource "aws_iam_user_policy" "iam_user_policy" {
  count         = var.create-new-policy ?  1 : 0
  name          = var.policy-name
  user          = var.user-name
  depends_on    = [
      module.iam_user
    ]
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "${var.policy-action}"
            "Resource": "${var.policy-resource}"
        }
    ]
})
}
