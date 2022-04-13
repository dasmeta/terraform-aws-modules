locals {
  name_formed   = replace(var.name, "/\\W|_|\\s/", "-")
  iam_user_name = coalesce(var.iam_user_name, "${local.name_formed}-s3-usr")
}
