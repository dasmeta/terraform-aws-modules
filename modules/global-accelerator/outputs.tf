output "accelerator_arn" {
  description = "ARN of the Global Accelerator."
  value       = module.this.arn
}

output "dns_name" {
  description = "IPv4 DNS name of the Global Accelerator."
  value       = module.this.dns_name
}

output "dual_stack_dns_name" {
  description = "Dual Stack DNS name of the Global Accelerator, or null for IPv4-only accelerators."
  value       = var.ip_address_type == "DUAL_STACK" ? module.this.dual_stack_dns_name : null
}

output "hosted_zone_id" {
  description = "Route 53 hosted-zone ID of the Global Accelerator."
  value       = module.this.hosted_zone_id
}

output "ip_sets" {
  description = "IP address sets assigned to the Global Accelerator."
  value       = module.this.ip_sets
}

output "listener_arns" {
  description = "Listener ARNs keyed by the original listener logical keys."
  value       = { for key, listener in module.this.listeners : key => listener.arn }
}

output "endpoint_group_arns" {
  description = "Endpoint-group ARNs keyed first by listener and then by the original group logical keys."
  value = {
    for listener_key, listener in var.listeners : listener_key => {
      for group_key in keys(listener.endpoint_groups) :
      group_key => module.this.endpoint_groups["${listener_key}:${group_key}"].arn
    }
  }
}
