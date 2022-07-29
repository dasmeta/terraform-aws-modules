module "iam_user" {
  source  = "dasmeta/modules/aws//modules/aws-iam-user"
  version = "0.36.1"

  create_user   = var.create_iam_user
  username      = local.iam_user_name
  console       = false
  create_policy = true
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : var.iam_user_actions,
        "Resource" : ["arn:aws:s3:::${var.name}", "arn:aws:s3:::${var.name}/*"]
      }
    ]
  })
}
