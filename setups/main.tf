module "sso-deploy" {
  source = "../sso-deploy"

  permission_sets = [
    {
      name               = "development",
      description        = "Give a user full admininstrator access to an account",
      policy_attachments = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      relay_state        = "",
      session_duration   = "",
      inline_policy      = "",
      tags               = {}
    },
    {
      name               = "accounting",
      description        = "Give a user full admininstrator access to an account",
      policy_attachments = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      relay_state        = "",
      session_duration   = "",
      inline_policy      = "",
      tags               = {}
    }
  ]

  account_assignments = [
    {
      account = "471767607298",
      permission_set_name = module.sso-deploy.permission_set_name["development"],
      permission_set_arn = module.sso-deploy.permission_set_arn["development"],
      principal_type = "GROUP",
      principal_name = "development"
    },
    {
      account = "471767607298",
      permission_set_name = module.sso-deploy.permission_set_name["accounting"],
      permission_set_arn = module.sso-deploy.permission_set_arn["accounting"],
      principal_type = "GROUP",
      principal_name = "accounting"
    }
    ]

  cluster_name   = "my-cluster"
  cluster_region = "eu-west-1"
  group_arn  = "arn:aws:iam::471767607298:role/AWSReservedSSO_development_6d8ab1c0b48350e7"
  rbac_group = "dev-group"
}

output "permission_set_arn" {
  value = module.sso-deploy.permission_set_arn
}





