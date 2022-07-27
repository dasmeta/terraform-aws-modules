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
    cluster_enabled_log_types = ["audit"]

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
  cluster_enabled_log_types = local.cluster_enabled_log_types
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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.31 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.4.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.31 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb-ingress-controller"></a> [alb-ingress-controller](#module\_alb-ingress-controller) | ../aws-load-balancer-controller | n/a |
| <a name="module_cloudwatch-metrics"></a> [cloudwatch-metrics](#module\_cloudwatch-metrics) | ../aws-cloudwatch-metrics | n/a |
| <a name="module_eks-cluster"></a> [eks-cluster](#module\_eks-cluster) | ../eks | n/a |
| <a name="module_external-secrets-prod"></a> [external-secrets-prod](#module\_external-secrets-prod) | ../external-secrets | n/a |
| <a name="module_fluent-bit"></a> [fluent-bit](#module\_fluent-bit) | ../fluent-bit | n/a |
| <a name="module_metrics-server"></a> [metrics-server](#module\_metrics-server) | ../metrics-server | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_log_bucket_name"></a> [alb\_log\_bucket\_name](#input\_alb\_log\_bucket\_name) | n/a | `string` | `""` | no |
| <a name="input_alb_log_bucket_prefix"></a> [alb\_log\_bucket\_prefix](#input\_alb\_log\_bucket\_prefix) | ALB-INGRESS-CONTROLLER | `string` | `""` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of VPC availability zones, e.g. ['eu-west-1a', 'eu-west-1b', 'eu-west-1c']. | `list(string)` | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR ip range. | `string` | n/a | yes |
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html) | `list(string)` | <pre>[<br>  "audit"<br>]</pre> | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | n/a | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Creating eks cluster name. | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Allows to set/change kubernetes cluster version, kubernetes version needs to be updated at leas once a year. Please check here for available versions https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html | `string` | `"1.21"` | no |
| <a name="input_enable_cloudwatch_metrics_for_prometheus"></a> [enable\_cloudwatch\_metrics\_for\_prometheus](#input\_enable\_cloudwatch\_metrics\_for\_prometheus) | CLOUDWATCH | `bool` | `false` | no |
| <a name="input_enable_metrics_server"></a> [enable\_metrics\_server](#input\_enable\_metrics\_server) | METRICS-SERVER | `bool` | `false` | no |
| <a name="input_external_secrets_namespace"></a> [external\_secrets\_namespace](#input\_external\_secrets\_namespace) | The namespace of external-secret operator | `string` | `"kube-system"` | no |
| <a name="input_fluent_bit_name"></a> [fluent\_bit\_name](#input\_fluent\_bit\_name) | FLUENT-BIT | `string` | `""` | no |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_manage_aws_auth"></a> [manage\_aws\_auth](#input\_manage\_aws\_auth) | n/a | `bool` | `true` | no |
| <a name="input_map_roles"></a> [map\_roles](#input\_map\_roles) | Additional IAM roles to add to the aws-auth configmap. | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_metrics_server_name"></a> [metrics\_server\_name](#input\_metrics\_server\_name) | n/a | `string` | `"metrics-server"` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Map of map of node groups to create. See `node_groups` module's documentation for more details | `any` | `{}` | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Private subnets of VPC. | `list(string)` | n/a | yes |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | n/a | `map(any)` | `{}` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Public subnets of VPC. | `list(string)` | n/a | yes |
| <a name="input_users"></a> [users](#input\_users) | n/a | `any` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Creating VPC name. | `string` | n/a | yes |
| <a name="input_worker_groups"></a> [worker\_groups](#input\_worker\_groups) | Worker groups. | `any` | <pre>[<br>  {<br>    "asg_max_size": 5,<br>    "instance_type": "t3.xlarge"<br>  }<br>]</pre> | no |
| <a name="input_worker_groups_launch_template"></a> [worker\_groups\_launch\_template](#input\_worker\_groups\_launch\_template) | A list of maps defining worker group configurations to be defined using AWS Launch Templates. See workers\_group\_defaults for valid keys. | `any` | `[]` | no |
| <a name="input_workers_group_defaults"></a> [workers\_group\_defaults](#input\_workers\_group\_defaults) | Worker group defaults. | `any` | <pre>{<br>  "root_volume_size": 50,<br>  "root_volume_type": "gp2"<br>}</pre> | no |
| <a name="input_write_kubeconfig"></a> [write\_kubeconfig](#input\_write\_kubeconfig) | Whether or not to create kubernetes config file. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_certificate"></a> [cluster\_certificate](#output\_cluster\_certificate) | n/a |
| <a name="output_cluster_host"></a> [cluster\_host](#output\_cluster\_host) | n/a |
| <a name="output_cluster_iam_role_name"></a> [cluster\_iam\_role\_name](#output\_cluster\_iam\_role\_name) | n/a |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | n/a |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | n/a |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | n/a |
| <a name="output_cluster_token"></a> [cluster\_token](#output\_cluster\_token) | n/a |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | n/a |
| <a name="output_eks_oidc_root_ca_thumbprint"></a> [eks\_oidc\_root\_ca\_thumbprint](#output\_eks\_oidc\_root\_ca\_thumbprint) | Grab eks\_oidc\_root\_ca\_thumbprint from oidc\_provider\_arn. |
| <a name="output_kubeconfig_filename"></a> [kubeconfig\_filename](#output\_kubeconfig\_filename) | n/a |
| <a name="output_map_user_data"></a> [map\_user\_data](#output\_map\_user\_data) | n/a |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | ## CLUSTER |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | ## VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
| <a name="output_vpc_private_subnets"></a> [vpc\_private\_subnets](#output\_vpc\_private\_subnets) | n/a |
| <a name="output_vpc_public_subnets"></a> [vpc\_public\_subnets](#output\_vpc\_public\_subnets) | n/a |
| <a name="output_worker_iam_role_name"></a> [worker\_iam\_role\_name](#output\_worker\_iam\_role\_name) | n/a |
<!-- END_TF_DOCS -->
