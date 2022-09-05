output "role_binding" {
  value = local.role_binding
}

output "data_psr" {
  value = data.aws_iam_roles.permission_set_arns
}

#output "data_psr_sso" {
#  value = data.aws_iam_roles.sso
#}

output "iam_permission_set_arns" {
  value = local.permission_set_role
}
