output "repository_id" {
  description = "ID of the CodeCommit repository."
  value       = aws_codecommit_repository.this.repository_id
}

output "repository_arn" {
  description = "ARN of the CodeCommit repository."
  value       = aws_codecommit_repository.this.arn
}

output "repository_name" {
  description = "Name of the CodeCommit repository."
  value       = aws_codecommit_repository.this.repository_name
}

output "clone_url_http" {
  description = "HTTP URL to clone the repository for IAM or root users."
  value       = aws_codecommit_repository.this.clone_url_http
}

output "clone_url_ssh" {
  description = "SSH URL to clone the repository for IAM users configuring SSH public keys."
  value       = aws_codecommit_repository.this.clone_url_ssh
}
