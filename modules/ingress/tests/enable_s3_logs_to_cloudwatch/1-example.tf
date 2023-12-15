data "aws_acm_certificate" "issued" {
  domain   = "test.dasmeta.com"
  statuses = ["ISSUED"]
}

module "ingress" {
  source = "../.."

  name      = "dev"
  hostname  = "test.dasmeta.com"
  scheme    = "internal"
  namespace = "default"

  enable_send_alb_logs_to_cloudwatch = true

  certificate_arn           = data.aws_acm_certificate.issued.arn
  healthcheck_path          = "/health"
  healthcheck_success_codes = "200-399"

  tls_hosts = ["test.dasmeta.com"]

  alarms = {
    sns_topic = "Default"
  }
}

data "aws_eks_cluster" "example" {
  name = "test-eks-spot-instances"
}

data "aws_eks_cluster_auth" "example" {
  name = "test-eks-spot-instances"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.example.token
}



output "ingress_all" {
  value       = module.ingress.ingress_all
  description = "Load Balancer All."
}
