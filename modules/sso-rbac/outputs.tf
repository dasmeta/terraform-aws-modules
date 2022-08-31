output "permission_sets" {
  value = aws_ssoadmin_permission_set.this
}

output "permission_set_arn" {
  value = {
  for k , v in aws_ssoadmin_permission_set.this : k => v.arn
  }
}

output "permission_set_name" {
 # value = aws_ssoadmin_permission_set.this.name[*]
  value = {
    for k , v in aws_ssoadmin_permission_set.this : k => v.name
  }
}