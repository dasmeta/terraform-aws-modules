locals {
  eks_oidc_root_ca_thumbprint = replace(module.eks-cluster[0].oidc_provider_arn, "/.*id//", "")
}

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks-cluster[0].cluster_id
# }

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
    root_volume_size = number
  }))
  default = [
    {
      instance_type = "t3.xlarge"
      asg_max_size  = 5
      root_volume_size = 50
    }
  ]
  description = "Worker groups."
}

variable "workers_group_defaults" {
  type = object({
    root_volume_type = string
    root_volume_size = number
  })
  default = {
    root_volume_type = "gp2"
    root_volume_size = 50
    kubelet_extra_args = "--node-labels=cluster_name=production,type=gpu_optimised --register-with-taints app=vums:NoSchedule"
  }
  description = "Worker group defaults."
}

variable "worker_groups_launch_template" {
  description = "A list of maps defining worker group configurations to be defined using AWS Launch Templates. See workers_group_defaults for valid keys."
  type        = any
  default     = []
}

variable "manage_aws_auth" {
  type = bool
  default = true
}

variable "map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}
