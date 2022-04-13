module "bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.0.1"

  bucket = var.name
  acl    = var.acl

  versioning = var.versioning

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }
}



module "iam_user" {
  source  = "dasmeta/modules/aws//modules/aws-iam-user"
  version = "0.25.5"

  create_user = var.create_iam_user
  username    = local.iam_user_name
  console     = false
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : var.iam_user_actions,
        "Resource" : "arn:aws:s3:::${var.name}/*"
      }
    ]
  })
}
