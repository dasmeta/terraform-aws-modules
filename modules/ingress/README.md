# Module setup ingress controller.

# Example 1. Minimal parameter set and create ingress on default annotations

```
module "ingress" {
  source   = "dasmeta/modules/aws//modules/ingress"

  alb_name = "test"
  hostname = "test3.devops.dasmeta.com"
}
```

# Example 2. Create ingress set annotations

```
module "ingress" {
  source   = "dasmeta/modules/aws//modules/ingress"

  alb_name = "test"
  hostname = "test3.devops.dasmeta.com"
  annotations = {
       "alb.ingress.kubernetes.io/load-balancer-name" = "test-ingress"
       "alb.ingress.kubernetes.io/scheme"             = "internet-facing"
       "alb.ingress.kubernetes.io/subnets"            = "subnet-0ebc13842a5f, subnet-05b72a3769b, subnet-0da2ece4bb4229"
       "alb.ingress.kubernetes.io/backend-protocol"   = "HTTP"
       "alb.ingress.kubernetes.io/certificate-arn"    = "arn:aws:acm:us-east-1:5********68:certificate/a55ee6eb****1706"
       "alb.ingress.kubernetes.io/group.name"         = "dev"
       "alb.ingress.kubernetes.io/listen-ports"       = "[{\"HTTPS\":443}, {\"HTTPS\":80}]"
       "kubernetes.io/ingress.class"                  = "alb"
     }
  path = [
    {
      service_name = "nginx"
      service_port = "80"
      path         = "/alb-terraform-created"
    }
  ]
}
```