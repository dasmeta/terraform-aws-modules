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

| Name                                                | Version |
| --------------------------------------------------- | ------- |
| <a name="provider_helm"></a> [helm](#provider_helm) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                         | Type     |
| ------------------------------------------------------------------------------------------------------------ | -------- |
| [helm_release.mongodb](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name                                                                                       | Description                                                              | Type                                                                  | Default        | Required |
| ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------ | --------------------------------------------------------------------- | -------------- | :------: |
| <a name="input_chart_version"></a> [chart_version](#input_chart_version)                   | n/a                                                                      | `string`                                                              | `"10.8.0"`     |    no    |
| <a name="input_cluster_certificate"></a> [cluster_certificate](#input_cluster_certificate) | n/a                                                                      | `string`                                                              | n/a            |   yes    |
| <a name="input_cluster_host"></a> [cluster_host](#input_cluster_host)                      | n/a                                                                      | `string`                                                              | n/a            |   yes    |
| <a name="input_cluster_token"></a> [cluster_token](#input_cluster_token)                   | n/a                                                                      | `string`                                                              | n/a            |   yes    |
| <a name="input_name"></a> [name](#input_name)                                              | Release name.                                                            | `string`                                                              | `"mongodb"`    |    no    |
| <a name="input_set"></a> [set](#input_set)                                                 | Value block with custom STRING values to be merged with the values yaml. | <pre>list(object({<br> name = string<br> value = string<br> }))</pre> | `null`         |    no    |
| <a name="input_setup"></a> [setup](#input_setup)                                           | Which mongodb setup to consider: standalone (default), replicaset.       | `string`                                                              | `"standalone"` |    no    |
| <a name="input_values"></a> [values](#input_values)                                        | Extra values                                                             | `list(string)`                                                        | `null`         |    no    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
