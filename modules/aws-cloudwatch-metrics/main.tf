
resource "aws_iam_policy" "this" {
  name        = "${var.cluster_name}-cloudwatch-metrics"
  description = "Permissions that are required to manage AWS cloudwatch metrics."

  policy = file("${path.module}/iam-policy.json")
}

resource "aws_iam_role" "aws-cloudwatch-metrics-role" {
  name = "${var.cluster_name}-cloudwatch-metrics-role"

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

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.aws-cloudwatch-metrics-role.name
}

resource "helm_release" "aws-cloudwatch-metrics" {
  name       = "aws-cloudwatch-metrics"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-cloudwatch-metrics"
  version    = "0.0.4"
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
    value = "aws-cloudwatch-metrics"
  }

  set {
    name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.aws-cloudwatch-metrics-role.name}"
  }
}
