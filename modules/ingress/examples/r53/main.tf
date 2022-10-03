locals {
  name = "test-ingress"
}

data "kubernetes_ingress_v1" "example" {
  metadata {
    name = local.name
  }
}

//Creates a k8s ingress resource
module "ingress" {
  source = "../.."

  name = local.name
}

//You already have a zone. It creates a record with an ALB.
module "route53" {
  source  = "dasmeta/modules/aws//modules/route53"
  version = "0.21.17"

  zone        = "example.com"
  create_zone = false
  records = [
    {
      name  = "test1.example.com"
      type  = "A"
      value = data.kubernetes_ingress_v1.example.status.0.load_balancer.0.ingress.0.hostname
    }
  ]
  ttl = "30"

  depends_on = [
    module.ingress
  ]
}
