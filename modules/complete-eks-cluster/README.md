# Why
To spin up complete eks with all necessary components.
Those include:
- vpc
- eks cluster
- alb ingress controller
- fluentbit
- external secrets
- metrics to cloudwatch

# How to run
```
locals {
  vpc_name = "your-vpc-name-goes-here",
  cidr = "172.16.0.0/16",
  availability_zones = data.aws_availability_zones.available.names
  private_subnets = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  public_subnets = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  
  public_subnet_tags = {
    "kubernetes.io/cluster/production"  = "shared"
    "kubernetes.io/role/elb"            = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/production"  = "shared"
    "kubernetes.io/role/internal-elb"   = "1"
  }

  cluster_name = "your-cluster-name-goes-here"
  alb_log_bucket_name = "your-log-bucket-name-goes-here"

  fluent_bit_name = "fluent-bit"
  log_group_name = "fluent-bit-cloudwatch-env"
}

module "prod_complete_cluster" {
  source = "dasmeta/modules/aws//complete-eks-cluster"

  version = "0.6.2"

  ### VPC
  vpc_name              = local.vpc_name
  cidr                  = local.cidr
  availability_zones    = local.availability_zones
  private_subnets       = local.private_subnets
  public_subnets        = local.public_subnets
  public_subnet_tags    = local.public_subnet_tags
  private_subnet_tags   = local.private_subnet_tags

  ### EKS
  cluster_name          = local.cluster_name
  manage_aws_auth       = true

  map_users             = [
    {
      userarn = "arn:aws:iam::4567856788:user/cluster.user.name"
      username = "cluster.user.name"
      groups = ["system:masters"]
    },
  ]

  worker_groups_launch_template = [
    {
      instance_type = "t3.xlarge"
      asg_max_size  = 5
      root_volume_size  = 50
      kubelet_extra_args = join(" ", [
        "--node-labels=cluster_name=${local.cluster_name},type=general"
      ])
    }
  ]
  worker_groups = [
    {
      instance_type = "t3.xlarge"
      asg_max_size  = 3
      root_volume_size  = 50
    }
  ]

  ### ALB-INGRESS-CONTROLLER
  alb_log_bucket_name = local.alb_log_bucket_name

  ### FLUENT-BIT
  fluent_bit_name = local.fluent_bit_name
  log_group_name = local.log_group_name

  # Should be refactored to install from cluster: for prod it has done from metrics-server.tf
  ### METRICS-SERVER
  # enable_metrics_server = false
  metrics_server_name = "metrics-server"
}
```
