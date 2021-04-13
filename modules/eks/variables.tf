output "oidc_provider_arn" {
  value = module.eks-cluster[0].oidc_provider_arn
}

locals {
  eks_oidc_root_ca_thumbprint = replace(module.eks-cluster[0].oidc_provider_arn, "/.*id//", "")
}

output "eks_oidc_root_ca_thumbprint" {
  value = local.eks_oidc_root_ca_thumbprint
  description = "Grab eks_oidc_root_ca_thumbprint from oidc_provider_arn."
}

# Required arguments
variable "vpc_id" {
  type = string
  description = "VPC id where to spin up the cluster."
}

variable "subnets" {
  type = list(string)
  description = "VPC subnets. Most probably those are the private ones."
}

variable "cluster_name" {
  type = string
  description = "Creating cluster name."
}

variable "cluster_version" {
  type = string
  default = "1.18"
  description = "Cluster version."
}

# Optional arguments
variable "create_cluster" {
  type = bool
  default = true
  description = "Whether or not to create cluster."
}

variable "write_kubeconfig" {
  type = bool
  default = true
  description = "Whether or not to create kubernetes config file."
}

variable "kubeconfig_output_path" {
  type = string
  default = "./"
  description = "Where to put kubeconfig file."
}

variable "enable_irsa" {
  type = bool
  default = true
  description = "Whether or not to enable OpenID connect protocol."
  # Needed to attach iam roles to service accounts. Example usage is ingress controller setup.
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html
}

variable "worker_groups" {
  type = list(object({
    instance_type = string
    asg_max_size  = number
  }))
  default = [
    {
      instance_type = "t3.xlarge"
      asg_max_size  = 5
    }
  ]
  description = "Worker groups."
}

variable "worker_group_defaults" {
  type = object({
    root_volume_type = string
  })
  default = {
    root_volume_type = "gp2"
  }
  description = "Worker group defaults."
}
