This module uses bitnami's mongodb chart.

## Usage example
In this case you have a `values-replicaset.yaml` file where all the configs are described and pass it to the module. 
`rootPassword` and `replicaSetKey` are variables in that file and are passed with terraform(it can be handled also with AWS Secrets MAnager).
```
module "mongodb" {
  source  = "dasmeta/modules/aws//modules/mongodb-replicaset"

  cluster_host        = data.aws_eks_cluster.cluster.endpoint
  cluster_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  cluster_token       = data.aws_eks_cluster_auth.cluster.token

  values = [templatefile("values-replicaset.yaml", {
    rootPassword  = "some-password"
    replicaSetKey = "some-key"
  })]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.mongodb](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | n/a | `string` | `"10.8.0"` | no |
| <a name="input_cluster_certificate"></a> [cluster\_certificate](#input\_cluster\_certificate) | n/a | `string` | n/a | yes |
| <a name="input_cluster_host"></a> [cluster\_host](#input\_cluster\_host) | n/a | `string` | n/a | yes |
| <a name="input_cluster_token"></a> [cluster\_token](#input\_cluster\_token) | n/a | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Release name. | `string` | `"mongodb"` | no |
| <a name="input_set"></a> [set](#input\_set) | Value block with custom STRING values to be merged with the values yaml. | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `null` | no |
| <a name="input_setup"></a> [setup](#input\_setup) | Which mongodb setup to consider: standalone (default), replicaset. | `string` | `"standalone"` | no |
| <a name="input_values"></a> [values](#input\_values) | Extra values | `list(string)` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->