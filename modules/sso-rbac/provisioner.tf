resource "null_resource" "provision1" {

  #You need eksctl installed and
  provisioner "local-exec" {
    command = "eksctl create iamidentitymapping --cluster ${var.cluster_name} --region ${var.cluster_region} --group ${var.rbac_group} --arn ${var.group_arn}"
  }
}

resource "null_resource" "provision2" {

  #You need eksctl installed and
  provisioner "local-exec" {
    command = "sleep 10 && eksctl create iamidentitymapping --cluster my-cluster --region eu-west-1 --group acc-viewers --arn arn:aws:iam::471767607298:role/AWSReservedSSO_accounting_38389ad3e523a8ce --username kubernetesdeleteme@dasmeta.com"
  }
}
