output "lb_arn" {
  description = "ARN of the Network Load Balancer."
  value       = module.this.arn
}

output "lb_arn_suffix" {
  description = "ARN suffix of the Network Load Balancer for CloudWatch dimensions."
  value       = module.this.arn_suffix
}

output "lb_dns_name" {
  description = "DNS name of the Network Load Balancer."
  value       = module.this.dns_name
}

output "lb_zone_id" {
  description = "Route53 zone ID of the Network Load Balancer."
  value       = module.this.zone_id
}

output "listener_arns" {
  description = "ARNs of listeners created by this module."
  value       = { for key, listener in module.this.listeners : key => listener.arn }
}

output "target_group_arns" {
  description = "ARNs of target groups created by this module."
  value       = { for key, target_group in module.this.target_groups : key => target_group.arn }
}

output "target_group_arn_suffixes" {
  description = "ARN suffixes of target groups for CloudWatch dimensions."
  value       = { for key, target_group in module.this.target_groups : key => target_group.arn_suffix }
}

output "security_group_id" {
  description = "ID of the module-managed security group, when created."
  value       = module.this.security_group_id
}

output "security_group_arn" {
  description = "ARN of the module-managed security group, when created."
  value       = module.this.security_group_arn
}

output "target_unhealthy_alarm_arns" {
  description = "ARNs of target unhealthy CloudWatch alarms."
  value       = { for key, alarm in aws_cloudwatch_metric_alarm.target_unhealthy : key => alarm.arn }
}
