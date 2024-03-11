data "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  depends_on = [
    kubernetes_ingress_v1.this_v1
  ]
}

data "aws_region" "current" {}

resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "30s"
}

data "aws_lb" "ingress" {
  name = var.name

  depends_on = [
    kubernetes_ingress_v1.this_v1,
    time_sleep.wait_30_seconds
  ]
}
