data "aws_iam_roles" "permission_set_arns" {
  for_each = { for kr in local.role_binding : kr.name => kr }
  path_prefix = "/aws-reserved/sso.amazonaws.com/eu-west-1/AWSReservedSSO_permission-set-${each.value.group}"
}

data "aws_iam_roles" "sso" {
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
}

module "eks_auth" {
  source = "aidanmelen/eks-auth/aws"
  eks    = var.eks_module

  map_roles = [for role_binding in local.role_binding : {
      rolearn  = [for role_arn in module.permission_set_roles.arns_without_path : role_arn if length(regexall(".+AWSReservedSSO_permission-set-${role_binding.group}.+", role_arn)) > 0][0]
      username = role_binding.group
      groups   = [role_binding.group]
    }
  ]
}


