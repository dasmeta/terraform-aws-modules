data "aws_caller_identity" "current" {}

resource "kubernetes_service_account" "example" {
  metadata {
    name        = "cwagent-prometheus"
    namespace   = var.namespace
    annotations = { "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.aws-cloudwatch-metrics-role.name}" }
  }
}
