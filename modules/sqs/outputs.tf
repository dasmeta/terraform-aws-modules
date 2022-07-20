output "queue_name" {
  description = "The name of the created Amazon SQS queue"
  value       = local.queue_name
}

output "queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = module.sqs.sqs_queue_id
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = module.sqs.sqs_queue_arn
}

output "queue_url" {
  description = "The url of the SQS queue"
  value       = module.sqs.sqs_queue_arn
}

output "username" {
  description = "The name of the IAM user who have access to created Amazon SQS queue to push/pull messages"
  value       = local.iam_username
}

output "access_key_id" {
  description = "The access key ID"
  value       = module.iam_user.iam_access_key_id
}

output "access_secret_key" {
  description = "The access key secret"
  value       = module.iam_user.iam_access_key_secret
  sensitive   = true
}

output "access_secret_key_insecure" {
  description = "The access key secret"
  value       = nonsensitive(module.iam_user.iam_access_key_secret)
}

output "access_secret_key_encrypted" {
  description = "The access key secret with pgp encryption"
  value       = module.iam_user.iam_access_key_encrypted_secret
}
