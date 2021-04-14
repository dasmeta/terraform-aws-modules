output "vpc_id" {
  value = module.vpc[0].vpc_id
}

output "vpc_private_subnets" {
  value = module.vpc[0].private_subnets
}
