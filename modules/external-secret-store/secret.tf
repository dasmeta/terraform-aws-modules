resource "kubernetes_secret" "store-secret" {
  metadata {
    name = "${local.sanitized-name}-awssm-secret"
  }

  data = {
    access-key        = var.create_user ? module.iam-user[0].iam_access_key_id : var.aws_access_key_id
    secret-access-key = var.create_user ? module.iam-user[0].iam_access_key_secret : var.aws_access_secret
  }
}
