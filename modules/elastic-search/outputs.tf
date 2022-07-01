output "arn" {
  description = "The ARN of the ES domain"
  value       = module.elastic_search.arn
}

output "endpoint" {
  description = "The endpoint of the ES domain"
  value       = module.elastic_search.endpoint
}

output "master_password" {
  description = "The master password of the ES domain"
  value       = module.elastic_search.master_password
}

output "master_username" {
  description = "The master username of the ES domain"
  value       = module.elastic_search.master_username
}
