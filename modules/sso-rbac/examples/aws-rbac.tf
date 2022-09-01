locals {
  aws_roles = [
    {
      name     = "view"
      policies = []
    }
  ]
  k8s_roles = [
    {
      name      = "view"
      resources = ["pods", "deployments"]
      actions   = ["get", "list", "watch"]
    }
  ]
  mysql_roles = [
    {
      name      = "view"
      resources = ["pods", "deployments"]
      actions   = ["get", "list", "watch"]
    }
  ]
  groups = [
    {
      group       = "group-1"
      description = ""
      namespace   = "group-1"
      roles       = ["view"]
    },
    {
      group     = "client-1-development-team"
      namespace = "client-1-test"
      roles     = ["view", "write"]
    },
    {
      group     = "client-1-development-team"
      namespace = "client-1-stg"
      roles     = ["view"]
    },
    {
      group     = "development-team"
      namespace = "client-1-stg"
      roles     = ["view"]
    },
    {
      group     = "development-team"
      namespace = "client-1-stg"
      roles     = ["view"]
    }
  ]
}

module "sso" {
  roles  = local.aws_roles
  groups = local.groups
}

module "iam" {
  roles  = local.aws_roles
  groups = local.groups
}

# module "sso-applications" {
#   applications = [module.eks, module.mysql]
#   depends_on   = [module.eks, module.mysql]
# }

module "eks" {
  auth    = "sso"
  sso_arn = module.sso.arn

  roles  = local.k8s_roles
  groups = local.groups

  depends_on = [
    module.sso
  ]
}

module "gke" {
  roles  = local.k8s_roles
  groups = local.groups
}

module "aks" {
  roles  = local.k8s_roles
  groups = local.groups
}

module "mysql" {
  roles  = local.mysql_roles
  groups = local.groups
}
