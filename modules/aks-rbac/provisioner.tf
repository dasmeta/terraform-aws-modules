resource "null_resource" "enable_azure_rbac" {

  #azure cli need to be installed and configured
  provisioner "local-exec" {
    command = "az aks update -g ${var.resource_group} -n ${var.aks_cluster_name} --enable-azure-rbac"
  }
}

resource "null_resource" "bind_admin_group" {

  depends_on = [null_resource.enable_azure_rbac]

  #azure cli need to be installed and configured
  provisioner "local-exec" {

    command = "az aks update -g ${var.resource_group} -n ${var.aks_cluster_name} --aad-admin-group-object-ids ${data.azuread_group.example.id}"

  }
}
