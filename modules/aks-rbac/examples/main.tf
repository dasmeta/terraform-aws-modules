module "sso_module" {
  source = "./module/path"


  admin_group_name = "kubeadmin"
  aks_cluster_name = "aks-cluster"
  resource_group   = "k8s"


  assignment = [{
    name = "role1"
    group = "development"
    namespace = "development"
    role = [local.role1]

  },{
    name = "role2"
    group = "accounting"
    namespace = "accounting"
    role = [local.role2]
  }]

}

locals {

  role1 = {
    actions = ["get", "list", "watch"]
    resources = ["deployments"]
  }

  role2 = {
    actions = ["get", "list", "watch"]
    resources = ["pods"]
  }
}
