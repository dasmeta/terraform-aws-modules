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

output "ingress_hostname" {
  value       = try(data.kubernetes_ingress_v1.ingress.status.0.load_balancer.0.ingress.0.hostname, null)
  description = "Load Balancer DNS name."
}
