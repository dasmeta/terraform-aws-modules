output "vpc_id" {
  value = module.vpc[0].vpc_id
}

output "vpc_private_subnets" {
  value = module.vpc[0].private_subnets
}

output "vpc_public_subnets" {
  value = module.vpc[0].public_subnets
}

output "vpc_cidr_block" {
  value = module.vpc[0].vpc_cidr_block
}

output "default_security_group_id" {
  value = module.vpc[0].default_security_group_id
}
