output "repository_id" {
  description = "ID of the CodeCommit repository."
  value       = try(aws_codecommit_repository.this[0].repository_id, null)
}

output "repository_arn" {
  description = "ARN of the CodeCommit repository."
  value       = try(aws_codecommit_repository.this[0].arn, null)
}

output "repository_name" {
  description = "Name of the CodeCommit repository."
  value       = try(aws_codecommit_repository.this[0].repository_name, null)
}

output "clone_url_http" {
  description = "HTTP URL to clone the repository for IAM or root users."
  value       = try(aws_codecommit_repository.this[0].clone_url_http, null)
}

output "clone_url_ssh" {
  description = "SSH URL to clone the repository for IAM users configuring SSH public keys."
  value       = try(aws_codecommit_repository.this[0].clone_url_ssh, null)
}
