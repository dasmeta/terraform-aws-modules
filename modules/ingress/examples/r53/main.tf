locals {
  name = "test-ingress"
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
      value = [module.ingress.ingress_hostname]
    }
  ]
  ttl = "30"

  depends_on = [
    module.ingress
  ]
}
