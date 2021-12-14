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
data "aws_availability_zones" "available" {}

locals {
    vpc_name = "dasmeta-prod-1"
    cidr     = "172.16.0.0/16"
    availability_zones = data.aws_availability_zones.available.names
    private_subnets = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
    public_subnets  = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
    
    # When you create EKS, API server endpoint access default is public. When you use private this variable value should be equal false.
    cluster_endpoint_public_access = true
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
  log_group_name  = "fluent-bit-cloudwatch-env"
}

module "prod_complete_cluster" {
  source  = "dasmeta/modules/aws//modules/complete-eks-cluste"

  ### VPC
  vpc_name              = local.vpc_name
  cidr                  = local.cidr
  availability_zones    = local.availability_zones
  private_subnets       = local.private_subnets
  public_subnets        = local.public_subnets
  public_subnet_tags    = local.public_subnet_tags
  private_subnet_tags   = local.private_subnet_tags

  cluster_endpoint_public_access = local.cluster_endpoint_public_access

  ### EKS
  cluster_name          = local.cluster_name
  manage_aws_auth       = true

  # IAM users username and group. By default value is ["system:masters"] 
  user = [
          {
            username = "devops1"
            group    = ["system:masters"]   
          },
          {
            username = "devops2"
            group    = ["system:kube-scheduler"]   
          },
          {
            username = "devops3"
          }
  ]
  
  # You can create node use node_group when you create node in specific subnet zone.(Note. This Case Ec2 Instance havn't specific name).
  # Other case you can use worker_group variable. 

  node_groups = {
    example =  {
      name  = "nodegroup"
      name-prefix     = "nodegroup"
      additional_tags = { 
          "Name"      = "node"
          "ExtraTag"  = "ExtraTag"  
      }

      instance_type   = "t3.xlarge"
      max_capacity    = 1
      disk_size       = 50
      create_launch_template = false
      subnet = ["subnet_id"]
    }
  }

  worker_groups_launch_template = [
    {
      name = "nodes"
      instance_type = "t3.xlarge"
      asg_max_size  = 5
      root_volume_size   = 50
      kubelet_extra_args = join(" ", [
        "--node-labels=cluster_name=${local.cluster_name},type=general"
      ])
    }
  ]

  worker_groups = [
    {
      name              = "nodes"
      instance_type     = "t3.xlarge"
      asg_max_size      = 3
      root_volume_size  = 50
    }
  ]

  ### ALB-INGRESS-CONTROLLER
  alb_log_bucket_name = local.alb_log_bucket_name

  ### FLUENT-BIT
  fluent_bit_name = local.fluent_bit_name
  log_group_name  = local.log_group_name

  # Should be refactored to install from cluster: for prod it has done from metrics-server.tf
  ### METRICS-SERVER
  # enable_metrics_server = false
  metrics_server_name     = "metrics-server"
}
```
