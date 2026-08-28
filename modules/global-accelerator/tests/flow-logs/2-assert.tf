output "accelerator_arn" {
  description = "ARN of the planned flow-log example accelerator."
  value       = module.global_accelerator.accelerator_arn
}

output "dns_name" {
  description = "DNS name of the planned flow-log example accelerator."
  value       = module.global_accelerator.dns_name
}

output "dual_stack_dns_name" {
  description = "Dual Stack DNS name, null for this IPv4 example."
  value       = module.global_accelerator.dual_stack_dns_name
}

output "hosted_zone_id" {
  description = "Route 53 hosted zone ID of the planned flow-log example accelerator."
  value       = module.global_accelerator.hosted_zone_id
}

output "ip_sets" {
  description = "IP sets assigned to the planned flow-log example accelerator."
  value       = module.global_accelerator.ip_sets
}

output "listener_arns" {
  description = "Listener ARNs keyed by logical listener name."
  value       = module.global_accelerator.listener_arns
}

output "endpoint_group_arns" {
  description = "Endpoint-group ARNs keyed by listener and group names."
  value       = module.global_accelerator.endpoint_group_arns
}
