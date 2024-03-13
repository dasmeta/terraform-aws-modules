output "efs_creation_token" {
  value = aws_efs_file_system.efs.creation_token
}

output "az" {
  value = local.az_name
}

output "id" {
  value = aws_efs_file_system.efs.id
}
