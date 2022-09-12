This module uses bitnami's mongodb chart to create replicaset or standalone.

## Usage example

In this case you have a `values-replicaset.yaml` file where all the configs are described and pass it to the module.
`rootPassword` and `replicaSetKey` are variables in that file and are passed with terraform(it can be handled also with AWS Secrets MAnager).

```
module "mongodb" {
  source  = "dasmeta/modules/aws//modules/mongodb"

  cluster_host        = data.aws_eks_cluster.cluster.endpoint
  cluster_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  cluster_token       = data.aws_eks_cluster_auth.cluster.token

  values = [templatefile("values-replicaset.yaml", {
    rootPassword  = "some-password"
    replicaSetKey = "some-key"
  })]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| <a name="input_arbiter_resources"></a> [arbiter\_resources](#input\_arbiter\_resources) | Allows to set cpu/memory resources Limits/Requests for arbiter. | <pre>object({<br>    limits = object({<br>      cpu    = string<br>      memory = string<br>    })<br>    requests = object({<br>      cpu    = string<br>      memory = string<br>    })<br>  })</pre> | <pre>{<br>  "limits": {<br>    "cpu": "",<br>    "memory": ""<br>  },<br>  "requests": {<br>    "cpu": "",<br>    "memory": ""<br>  }<br>}</pre> | no |
| <a name="input_architecture"></a> [architecture](#input\_architecture) | n/a | `string` | `"replicaset"` | no |
| <a name="input_cluster_certificate"></a> [cluster\_certificate](#input\_cluster\_certificate) | n/a | `string` | n/a | yes |
| <a name="input_cluster_host"></a> [cluster\_host](#input\_cluster\_host) | n/a | `string` | n/a | yes |
| <a name="input_cluster_token"></a> [cluster\_token](#input\_cluster\_token) | n/a | `string` | n/a | yes |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | n/a | `string` | `"4.4.11-debian-10-r5"` | no |
| <a name="input_livenessprobe_initialdelayseconds"></a> [livenessprobe\_initialdelayseconds](#input\_livenessprobe\_initialdelayseconds) | n/a | `string` | `"30"` | no |
| <a name="input_name"></a> [name](#input\_name) | Release name. | `string` | `"mongodb"` | no |
| <a name="input_persistence_annotations"></a> [persistence\_annotations](#input\_persistence\_annotations) | n/a | `any` | `null` | no |
| <a name="input_persistence_size"></a> [persistence\_size](#input\_persistence\_size) | n/a | `string` | `"8Gi"` | no |
| <a name="input_readinessprobe_initialdelayseconds"></a> [readinessprobe\_initialdelayseconds](#input\_readinessprobe\_initialdelayseconds) | n/a | `string` | `"5"` | no |
| <a name="input_replicaset_key"></a> [replicaset\_key](#input\_replicaset\_key) | n/a | `string` | n/a | yes |
| <a name="input_resources"></a> [resources](#input\_resources) | Allows to set cpu/memory resources Limits/Requests for deployment. | <pre>object({<br>    limits = object({<br>      cpu    = string<br>      memory = string<br>    })<br>    requests = object({<br>      cpu    = string<br>      memory = string<br>    })<br>  })</pre> | <pre>{<br>  "limits": {<br>    "cpu": "300m",<br>    "memory": "500Mi"<br>  },<br>  "requests": {<br>    "cpu": "300m",<br>    "memory": "500Mi"<br>  }<br>}</pre> | no |
| <a name="input_root_password"></a> [root\_password](#input\_root\_password) | n/a | `string` | n/a | yes |
| <a name="input_set"></a> [set](#input\_set) | Value block with custom STRING values to be merged with the values yaml. | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `null` | no |
| <a name="input_setup"></a> [setup](#input\_setup) | Which mongodb setup to consider: standalone (default), replicaset. | `string` | `"standalone"` | no |
| <a name="input_values"></a> [values](#input\_values) | Extra values | `list(string)` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
