data "aws_ssoadmin_instances" "this" {}

resource "aws_ssoadmin_permission_set" "this" {
  for_each     = { for kr in var.assignment : kr.group => kr }
  name         = "permission-set-${each.key}-${random_integer.random.result}"
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each           = { for kr in var.assignment : kr.group => kr }
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess" #Configure
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
}

resource "random_integer" "random" {
  max = 5000
  min = 1000
}

module "permission_set_roles" {
  depends_on = [aws_ssoadmin_managed_policy_attachment.this]
  source     = "github.com/thoughtbot/terraform-aws-sso-permission-set-roles.git"
}
