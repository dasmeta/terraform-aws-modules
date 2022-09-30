output "name" {
  value       = var.name
  description = "The name of Ingress."
}

output "group_name" {
  value       = local.group_name
  description = "The Ingress group name."
}

output "annotations" {
  value       = local.annotations
  description = "Ingress resource's annotations."
}
