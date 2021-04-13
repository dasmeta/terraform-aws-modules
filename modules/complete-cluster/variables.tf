# VPC
variable "vpc_name" {
  type = string
  description = "Creating VPC name."
}

variable "cidr" {
  type = string
  # default = "172.16.0.0/16"
  description = "CIDR ip range."
}

variable "availability_zones" {
  type = list(string)
  description = "List of VPC availability zones, e.g. ['eu-west-1a', 'eu-west-1b', 'eu-west-1c']."
}

variable "private_subnets" {
  type = list(string)
  # default = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  description = "Private subnets of VPC."
}

variable "public_subnets" {
  type = list(string)
  # default = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  description = "Public subnets of VPC."
}

# EKS
variable "cluster_name" {
  type = string
  description = "Creating eks cluster name."
}
