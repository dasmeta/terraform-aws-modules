# Required arguments
variable "vpc_id" {
  type        = string
  description = "VPC id where to spin up the cluster."
}

variable "subnets" {
  type        = list(string)
  description = "VPC subnets. Most probably those are the private ones."
}

variable "cluster_name" {
  type        = string
  description = "Creating cluster name."
}

variable "cluster_version" {
  type        = string
  default     = "1.22"
  description = "Cluster version."
}

# Optional arguments
variable "create_cluster" {
  type        = bool
  default     = true
  description = "Whether or not to create cluster."
}

variable "enable_irsa" {
  type        = bool
  default     = true
  description = "Whether or not to enable OpenID connect protocol."
  # Needed to attach iam roles to service accounts. Example usage is ingress controller setup.
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html
}

variable "worker_groups" {
  description = "self_managed_node_group_defaults."
  type        = any
  default     = {}
}

variable "workers_group_defaults" {
  description = "Map of self-managed node group definitions to create."
  type        = any
  default     = {}
}

variable "node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type        = any
  default = {
    default = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.medium"]
    }
  }
}


variable "node_groups_default" {
  description = "Map of EKS managed node group default configurations"
  type        = any
  default = {
    disk_size      = 50
    instance_types = ["t3.medium"]
  }
}

variable "cluster_endpoint_public_access" {
  description = "When you create EKS, API server endpoint access default is public. When you use private this variable value should be equal false"
  type        = bool
  default     = true
}

variable "users" {
  type = any
}

variable "cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
  default     = ["audit"]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}
