resource "kubectl_manifest" "main" {
    yaml_body = templatefile("${path.module}/secret-store.tmpl", {
      name = var.name
      region = var.region
      controller = var.controller
      aws_access_key_id = var.create_user ? module.iam_iam-user.iam_access_key_id : var.aws_access_key_id
      aws_access_secret = var.create_user ? module.iam_iam-user.iam_access_key_secret : var.aws_access_secret
    })
}
