# todo
- Goldilocks is a Kubernetes controller that provides a dashboard that gives recommendations on how to set your resource requests.

## Usage

# Case 1

The module create Goldilocks installation prerequisites. The module default create the prerequisites.

° vertical-pod-autoscaler configure in the cluster
° metrics-server 

```
module "goldilocks" {
  source               = "dasmeta/modules/aws//modules/goldilocks"
  namespaces           = ["default"]
  create_metric_server = false
  zone_name            = "example.com"
  hostname             = "goldilock.example.com"
  alb_certificate_arn  = "arn:aws:acm:us-east-1:5********68:certificate/1125ea15-****32d1b"
  alb_subnet           = "subnet-0db50f385c*, subnet-0a*, subnet-08eac866b7bfe*3"
  userpoolarn          = "arn:aws:cognito-idp:us-east-1:5*******68:userpool/us-eat-1_nr*y6"
  userpoolclientid     = "4k1n0gag*fvqa1g"
  userpooldomain       = "goldilock.auth.us-east-1.amazoncognito.com"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ingress"></a> [ingress](#module\_ingress) | dasmeta/modules/aws//modules/goldilocks/ingress | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.goldilocks_deploy](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metric_server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.vpa](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.create_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [null_resource.vpa_configure](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_certificate_arn"></a> [alb\_certificate\_arn](#input\_alb\_certificate\_arn) | Domain Certificate ARN | `string` | `""` | no |
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | n/a | `string` | `"goldilocks-dashboard"` | no |
| <a name="input_alb_subnet"></a> [alb\_subnet](#input\_alb\_subnet) | Ingress Annotations Add  EKS Public Subnet | `string` | `""` | no |
| <a name="input_auth"></a> [auth](#input\_auth) | n/a | <pre>object({<br>    userPoolARN      = string,<br>    userPoolClientID = string,<br>    userPoolDomain   = string<br>  })</pre> | n/a | yes |
| <a name="input_create_dashboard_ingress"></a> [create\_dashboard\_ingress](#input\_create\_dashboard\_ingress) | Access Goldilocks Dashboard | `bool` | `true` | no |
| <a name="input_create_metric_server"></a> [create\_metric\_server](#input\_create\_metric\_server) | Create metric server | `bool` | `true` | no |
| <a name="input_create_vpa_server"></a> [create\_vpa\_server](#input\_create\_vpa\_server) | VPA configure in the cluster | `bool` | `true` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | n/a | `string` | `"goldilocks.example.com"` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | Goldilocks labels on your namespaces | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | Domain Name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->