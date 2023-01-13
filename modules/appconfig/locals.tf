locals {
  deployments = flatten([for env in var.environments : [for deploy in env.deploys : {
    environment = env.name
    config      = deploy.config
    version     = deploy.version
    strategy    = deploy.strategy
  }]])
}
