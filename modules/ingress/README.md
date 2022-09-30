# Module setup ingress controller.

# Example 1. Minimal parameter set and create ingress on default annotations

```terraform
module "ingress" {
  source   = "dasmeta/modules/aws//modules/ingress"

  alb_name = "test"
  hostname = "test3.devops.dasmeta.com"

  annotations = {
    "alb.ingress.kubernetes.io/certificate-arn"    = "arn:aws:acm:us-east-1:5********68:certificate/a55ee6eb****1706"
  }
}
```

# Example 2. create ingress for apiVersion: extensions/v1beta1

```terraform
module "ingress" {
  source   = "dasmeta/modules/aws//modules/ingress"

  alb_name = "test"
  hostname = "test3.devops.dasmeta.com"
  api_version = extensions/v1beta1

  annotations = {
    "alb.ingress.kubernetes.io/certificate-arn"    = "arn:aws:acm:us-east-1:5********68:certificate/a55ee6eb****1706"
  }
}
```

# Example 3. Create ingress override annotations and rules
1.If you want to use a port with number for an Ingress rule, just pass it to `service_port_number` and pass null to `service_port_name`.
2.Otherwise you can use `use-annotation` value for the port, in this case pass it to `service_port_name` and pass null to `service_port_number`.
  Also, for this case you have to pass a `"alb.ingress.kubernetes.io/actions.${action-name}"` annotation, where `${action-name}` has to be specified and also used as the `service_name` in Ingress rule.

```terraform
module "ingress" {
  source   = "dasmeta/modules/aws//modules/ingress"

  alb_name = "test"
  hostname = "test.devops.dasmeta.com"
  annotations = {
       "alb.ingress.kubernetes.io/load-balancer-name"   = "test-ingress"
       "alb.ingress.kubernetes.io/scheme"               = "internet-facing"
       "alb.ingress.kubernetes.io/subnets"              = "subnet-0ebc13842a5f, subnet-05b72a3769b, subnet-0da2ece4bb4229"
       "alb.ingress.kubernetes.io/backend-protocol"     = "HTTP"
       "alb.ingress.kubernetes.io/certificate-arn"      = "arn:aws:acm:us-east-1:5********68:certificate/a55ee6eb****1706"
       "alb.ingress.kubernetes.io/actions.response-200" = "{\"Type\": \"fixed-response\", \"FixedResponseConfig\": { \"ContentType\": \"text/plain\", \"StatusCode\": \"200\", \"MessageBody\": \"Hello!\"}}"
       "alb.ingress.kubernetes.io/group.name"           = "dev"
       "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTPS\":443}, {\"HTTPS\":80}]"
       "kubernetes.io/ingress.class"                    = "alb"
     }
  path = [
    {
      service_name = "nginx"
      service_port_number = "80"
      service_port_name = null
      path         = "/alb-terraform-created"
    },
    {
      service_name = "response-200"
      service_port_number = null
      service_port_name = "use-annotation"
      path         = "/200"
    }
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 0.15.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_ingress.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) | resource |
| [kubernetes_ingress_v1.this_v1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | Ingress name | `string` | n/a | yes |
| <a name="input_annotations"></a> [annotations](#input\_annotations) | n/a | `any` | `{}` | no |
| <a name="input_api_version"></a> [api\_version](#input\_api\_version) | The api version of ingress, can be networking/v1 and extensions/v1beta1 for now | `string` | `"networking/v1"` | no |
| <a name="input_default_backend"></a> [default\_backend](#input\_default\_backend) | n/a | <pre>object({<br>    service_name = string<br>    service_port = string<br>  })</pre> | <pre>{<br>  "service_name": null,<br>  "service_port": null<br>}</pre> | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Hostname | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | `"default"` | no |
| <a name="input_path"></a> [path](#input\_path) | n/a | <pre>list(object({<br>    service_name        = string<br>    service_port_number = string<br>    service_port_name   = string<br>    path                = string<br>  }))</pre> | <pre>[<br>  {<br>    "path": "/200",<br>    "service_name": "response-200",<br>    "service_port_name": "use-annotation",<br>    "service_port_number": null<br>  }<br>]</pre> | no |
| <a name="input_tls_hosts"></a> [tls\_hosts](#input\_tls\_hosts) | Hosts are a list of hosts included in the TLS certificate. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_name"></a> [alb\_name](#output\_alb\_name) | The name of alb generated after apply |
| <a name="output_annotations"></a> [annotations](#output\_annotations) | The annotations that created ingress will get |
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | The ingress group name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
