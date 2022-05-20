output "role_arn" {
  value = aws_iam_role.role.arn
}

output "group_name" {
  value = local.group_name
}
