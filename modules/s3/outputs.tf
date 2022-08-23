output "s3_bucket_id" {
  description = "The bucket name"
  value       = module.bucket.s3_bucket_id
}

output "s3_bucket_website_endpoint" {
  description = "The access key secret"
  value       = module.bucket.s3_bucket_website_endpoint
}

output "iam_user_name" {
  description = "The user's name"
  value       = module.iam_user.iam_user_name
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = module.iam_user.iam_user_arn
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = module.iam_user.iam_access_key_id
}

output "iam_access_key_secret" {
  description = "The access key secret"
  value       = module.iam_user.iam_access_key_secret
  sensitive   = true
}
