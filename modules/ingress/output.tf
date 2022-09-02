output "alb_name" {
  value       = var.alb_name
  description = "The name of alb generated after apply"
}

output "group_name" {
  value       = local.group_name
  description = "The ingress group name"
}

output "annotations" {
  value       = local.annotations
  description = "The annotations that created ingress will get"
}
