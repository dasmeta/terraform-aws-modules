# todo

- Goldilocks is a Kubernetes controller that provides a dashboard that gives recommendations on how to set your resource requests.

## Usage

# Case 1

The module create Goldilocks installation prerequisites. The module default create the prerequisites.

° vertical-pod-autoscaler configure in the cluster
° metrics-server

```
module "goldilocks" {
  source                   =  "dasmeta/modules/aws//modules/goldilocks"
  namespaces               = ["default"]
  create_metric_server     = false
  create_dashboard_ingress = false
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| <a name="module_ingress"></a> [ingress](#module\_ingress) | dasmeta/modules/aws//modules/ingress | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [helm_release.goldilocks_deploy](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metric_server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.vpa](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [null_resource.vpa_configure](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_certificate_arn"></a> [alb\_certificate\_arn](#input\_alb\_certificate\_arn) | Domain Certificate ARN | `string` | `""` | no |
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | ALB name | `string` | `"goldilocks-dashboard"` | no |
| <a name="input_alb_subnet"></a> [alb\_subnet](#input\_alb\_subnet) | Ingress Annotations Add  EKS Public Subnet | `string` | `""` | no |
| <a name="input_auth"></a> [auth](#input\_auth) | Cognito User pool info(userPoolARN,userPoolClientID,userPoolDomain) | <pre>object({<br>    userPoolARN      = string,<br>    userPoolClientID = string,<br>    userPoolDomain   = string<br>  })</pre> | <pre>{<br>  "userPoolARN": "",<br>  "userPoolClientID": "",<br>  "userPoolDomain": ""<br>}</pre> | no |
| <a name="input_create_dashboard_ingress"></a> [create\_dashboard\_ingress](#input\_create\_dashboard\_ingress) | Access Goldilocks Dashboard | `bool` | `true` | no |
| <a name="input_create_metric_server"></a> [create\_metric\_server](#input\_create\_metric\_server) | Create metric server | `bool` | `true` | no |
| <a name="input_create_vpa_server"></a> [create\_vpa\_server](#input\_create\_vpa\_server) | VPA configure in the cluster | `bool` | `true` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Hostname | `string` | `"goldilocks.example.com"` | no |
| <a name="input_namespaces"></a> [namespaces](#input\_namespaces) | Goldilocks labels on your namespaces | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_zone_name"></a> [zone\_name](#input\_zone\_name) | Domain Name | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
