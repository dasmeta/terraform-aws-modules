data "tls_certificate" "cluster" {
  url = var.cluster_oidc_issuer
  # url = module.eks-cluster-production.cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = concat([data.tls_certificate.cluster.certificates.0.sha1_fingerprint], var.oidc_thumbprint_list)
  url = var.cluster_oidc_issuer
}

# data "local_file" "iam-policy-json" {
#   filename = var.iam_policy_json
# }

resource "aws_iam_policy" "this" {
  name        = "${var.cluster_name}-alb-management"
  description = "Permissions that are required to manage AWS Application Load Balancers."
  # path        = "."
  # We use a heredoc for the policy JSON so that we can more easily diff and
  # copy/paste from upstream.
  # Source: `curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.1.0/docs/install/iam_policy.json`
  # policy = data.local_file.iam-policy-json.content
  # policy = file("${path.module}/iam-policy.json")

  policy = file("${path.module}/iam-policy.json")

}



resource "aws_iam_role" "aws-load-balancer-role" {
  name = var.cluster_name

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

data "aws_caller_identity" "current" {}

# resource "aws_iam_role_policy_attachment" "AWSLoadBalancerControllerIAMPolicy" {
#   policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/AWSLoadBalancerControllerIAMPolicy"
#   role       = aws_iam_role.aws-load-balancer-role.name
# }

resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.1.6"
  namespace  = var.namespace

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name = "clusterName"
    value = var.cluster_name
  }

  # set {
  #   name = "serviceAccount.create"
  #   value = false
  # }

  set {
    name = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  # # @todo check and remove
  # set {
  #   name = "enableWaf"
  #   value = "false"
  # }

  # set {
  #   name = "enableWafv2"
  #   value = "false"
  # }

  set {
    name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.aws-load-balancer-role.name}"
    # value = "eks.amazonaws.com/role-arn=arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.aws-load-balancer-role.name}"
  }
}

# resource "null_resource" "whatever" {
#   eksctl utils associate-iam-oidc-provider \
#     --region eu-central-1 \
#     --cluster stage-6 \
#     --approve
#     --profile pushmetrics
# }

# resource "null_resource" "whatever" {
#   curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
# }

# resource "null_resource" "whatever" {
#   aws iam create-policy \
#     --policy-name AWSLoadBalancerControllerIAMPolicy \
#     --policy-document file://iam-policy.json
# }

# resource "null_resource" "whatever" {
#   eksctl create iamserviceaccount \
#     --cluster=<cluster-name> \
#     --namespace=kube-system \
#     --name=aws-load-balancer-controller \
#     --attach-policy-arn=arn:aws:iam::<AWS_ACCOUNT_ID>:policy/AWSLoadBalancerControllerIAMPolicy \
#     --approve
# }
