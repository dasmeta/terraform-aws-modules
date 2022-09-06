# How To
This module is used to organize AWS SSO group and EKS RBAC Syncronization


### Example 1


```
module "sso_module" {
source = "../module"

eks_module = module.eks

assignment = [{
name      = "role1"
group     = "development"
namespace = "development"
role      = [local.role1]

    }, {
    name      = "role2"
    group     = "accounting"
    namespace = "accounting"
    role      = [local.role2]
}]
}

locals {

role1 = {
actions   = ["get", "list", "watch"]
resources = ["deployments"]
}

role2 = {
actions   = ["get", "list", "watch"]
resources = ["pods"]
}
}

output "iam_permission_set_arns" {
value = module.sso_module.iam_permission_set_arns
}
```
