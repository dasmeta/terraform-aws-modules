resource "kubernetes_secret" "store-secret" {
  metadata {
    name = "${var.name}-awssm-secret"
  }

  data = {
    access-key = var.aws_access_key
    secret-access-key = var.aws_access_secret
  }

  # type = "kubernetes.io/basic-auth"
}
