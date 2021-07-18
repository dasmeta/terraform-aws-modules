data "http" "ingress-policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.1/docs/install/iam_policy.json"

  request_headers = {
    Accept = "application/json"
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.cluster_name}-alb-management"
  description = "Permissions that are required to manage AWS Application Load Balancers."
  # path        = "."
  # We use a heredoc for the policy JSON so that we can more easily diff and
  # copy/paste from upstream.
  # Source: `curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.1/docs/install/iam_policy.json`
  # policy = data.local_file.iam-policy-json.content
  # policy = file("${path.module}/iam-policy.json")

  policy = file("${path.module}/iam-policy.json")
  # policy = data.http.ingress-policy.body
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
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${var.oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.${data.aws_region.current.name}.amazonaws.com/id/${var.eks_oidc_root_ca_thumbprint}:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AWSLoadBalancerControllerIAMPolicy" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.aws-load-balancer-role.name
}

resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.2.3"
  namespace  = var.namespace

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name = "clusterName"
    value = var.cluster_name
  }

  set {
    name = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.aws-load-balancer-role.name}"
  }
}
