output "lb_dns_name" {
  description = "DNS name of the created Network Load Balancer."
  value       = module.this.lb_dns_name
}

output "security_group_id" {
  description = "ID of the module-managed Network Load Balancer security group."
  value       = module.this.security_group_id
}

output "target_unhealthy_alarm_arns" {
  description = "ARNs of unhealthy-target alarms created by the module."
  value       = module.this.target_unhealthy_alarm_arns
}
