resource "aws_iam_policy" "this" {
  name        = "${var.cluster_name}-fluent-bit"
  description = "Permissions that are required to manage AWS cloudwatch metrics by fluent bit"

  policy = file("${path.module}/iam-policy.json")
}

resource "aws_iam_role" "fluent-bit" {
  name = "${var.cluster_name}-fluent-bit"

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

locals {
  fluent_name = var.fluent_bit_name != "" ? var.fluent_bit_name : "${var.cluster_name}-${var.cluster_name}"
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.fluent-bit.name
}

resource "helm_release" "fluent-bit" {
  name       = local.fluent_name
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  version    = "0.15.4"
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
    value = "fluent-bit"
  }

  set {
    name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.fluent-bit.name}"
  }
}
