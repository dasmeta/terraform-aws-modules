data "aws_caller_identity" "current" {}

locals {
  aws_role_principal = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  group_name         = "${var.name}-group"
}

resource "aws_iam_group" "group" {
  name = local.group_name
}

resource "aws_iam_group_membership" "team" {
  name = var.name

  users = var.usernames
  group = aws_iam_group.group.name
}

resource "aws_iam_policy" "policy" {
  name = var.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_role" "role" {
  name = var.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = local.aws_role_principal
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = var.name
  users      = var.usernames
  roles      = [aws_iam_role.role.name]
  groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "kubernetes_role" "k8s_role" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  dynamic "rule" {
    for_each = var.rule
    content {
      api_groups = rule.value["api_groups"]
      resources  = rule.value["resources"]
      verbs      = rule.value["verbs"]
    }
  }
}

resource "kubernetes_role_binding" "k8s_bind_role" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  role_ref {
    name      = var.name
    kind      = "Role"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    name      = local.group_name
    kind      = "Group"
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [
    kubernetes_role.k8s_role,
    kubernetes_namespace.namespace
  ]

}

resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.namespace
  }
}
