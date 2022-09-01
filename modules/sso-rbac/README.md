```terraform

module "sso-deploy" {
  source = "/Users/mianv/Documents/terraform/dasmeta/terraform-aws-modules/modules/sso-rbac"

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
      account             = "471767607298",
      permission_set_name = module.sso-deploy.permission_set_name["development"],
      permission_set_arn  = module.sso-deploy.permission_set_arn["development"],
      principal_type      = "GROUP",
      principal_name      = "development"
    },
    {
      account             = "471767607298",
      permission_set_name = module.sso-deploy.permission_set_name["accounting"],
      permission_set_arn  = module.sso-deploy.permission_set_arn["accounting"],
      principal_type      = "GROUP",
      principal_name      = "accounting"
    }
  ]

  cluster_name   = "my-cluster"
  cluster_region = "eu-west-1"
  group_arn      = "arn:aws:iam::471767607298:role/AWSReservedSSO_development_6d8ab1c0b48350e7"
  rbac_group     = "dev-group"



  rbac_rule = [{
    name           = "dev-view"
    namespace      = "development"
    api_groups     = [""]
    resources      = ["pods"]
    resource_names = ["foo"]
    verbs          = ["get", "list", "watch"]
  },

    {
      name           = "acc-view"
      namespace      = "accounting"
      api_groups     = [""]
      resources      = ["pods"]
      resource_names = ["foo"]
      verbs          = ["get", "list", "watch"]
    }
  ]

  rbac_role_binding = [{

    rolebinding_name = "view_pods_binding_dev"
    role_name        = "dev-view"
    namespace        = "development"
    principal_kind   = "Group"
    role_kind        = "Role"
    group_name       = "dev-viewers"
    api_groups       = "rbac.authorization.k8s.io"
  }]
}
```