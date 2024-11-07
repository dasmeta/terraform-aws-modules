data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "ses_policy" {
  statement {
    actions = ["ses:SendEmail", "ses:SendRawEmail"]
    effect  = "Allow"
    resources = [
      "arn:aws:ses:${local.region}:${data.aws_caller_identity.current.account_id}:identity/*"
    ]
  }
}

resource "aws_iam_group" "ses_group" {
  name = "${var.prefix}ses_users"
  path = "/"
}

resource "aws_iam_user" "ses_user" {
  count = length(var.mail_users)
  name  = "ses_${var.mail_users[count.index]}"
  path  = "/"
}

resource "aws_iam_group_membership" "ses_user_group" {
  name  = "SES users"
  users = aws_iam_user.ses_user[*].name
  group = aws_iam_group.ses_group.name
}

resource "aws_iam_group_policy" "ses_group_policy" {
  name   = "sendMailSES"
  group  = aws_iam_group.ses_group.name
  policy = data.aws_iam_policy_document.ses_policy.json
}

resource "aws_iam_access_key" "ses_user" {
  count = length(var.mail_users)
  user  = aws_iam_user.ses_user[count.index].name
}
