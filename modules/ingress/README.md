# Module setup ingress controller.

# Example 1. Minimal parameter set default annotatandions

```terraform
module "ingress" {
  source   = "dasmeta/modules/aws//modules/ingress"

  name = "test-ingress"
}
```

# Example 2. Create ingress with an existing certificate, host and custom values for annotations and rules
1.If you want to use a port with number for an Ingress rule, just pass it to `service_port_number` and pass null to `service_port_name`.
2.Otherwise you can use `use-annotation` value for the port, in this case pass it to `service_port_name` and pass null to `service_port_number`.
  Also, for this case you have to pass a `"alb.ingress.kubernetes.io/actions.${action-name}"` annotation, where `${action-name}` has to be specified and also used as the `service_name` in Ingress rule.

```terraform
module "ingress" {
  source   = "dasmeta/modules/aws//modules/ingress"

  name = "test"
  hostname = "test.devops.dasmeta.com"

  certificate_arn          = "arn:aws:acm:us-east-1:5********68:certificate/a55ee6eb****1706"
  ssl_policy               = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  healthcheck_path         = "/health"
  success_codes            = "200-399"

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
| [kubernetes_ingress_v1.this_v1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_protocol"></a> [backend\_protocol](#input\_backend\_protocol) | Specifies the protocol used when route traffic to pods. | `string` | `"HTTP"` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | Specifies the ARN of one or more certificate managed by AWS Certificate Manager. If the alb.ingress.kubernetes.io/certificate-arn annotation is not specified, the controller will attempt to add certificates to listeners that require it by matching available certs from ACM with the host field in each listener's ingress rule. | `string` | `""` | no |
| <a name="input_default_backend"></a> [default\_backend](#input\_default\_backend) | n/a | <pre>object({<br>    service_name = string<br>    service_port = string<br>  })</pre> | <pre>{<br>  "service_name": null,<br>  "service_port": null<br>}</pre> | no |
| <a name="input_healthcheck_path"></a> [healthcheck\_path](#input\_healthcheck\_path) | Specifies the HTTP path when performing health check on targets. | `string` | `"/"` | no |
| <a name="input_healthcheck_success_codes"></a> [healthcheck\_success\_codes](#input\_healthcheck\_success\_codes) | Specifies the HTTP status code that should be expected when doing health checks against the specified health check path. | `string` | `"200"` | no |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Host is the fully qualified domain name of a network host. | `string` | `null` | no |
| <a name="input_listen_ports"></a> [listen\_ports](#input\_listen\_ports) | Specifies the ports that ALB used to listen on. | `string` | `"80"` | no |
| <a name="input_load_balancer_attributes"></a> [load\_balancer\_attributes](#input\_load\_balancer\_attributes) | Specifies Load Balancer Attributes that should be applied to the ALB. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Ingress, must be unique. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | K8s namespace where the Ingress will be created. | `string` | `"default"` | no |
| <a name="input_path"></a> [path](#input\_path) | Path array of path regex associated with a backend. Incoming urls matching the path are forwarded to the backend. | <pre>list(object({<br>    name = string<br>    port = string<br>    path = string<br>  }))</pre> | `null` | no |
| <a name="input_scheme"></a> [scheme](#input\_scheme) | Specifies whether your LoadBalancer will be internet facing. | `string` | `"internet-facing"` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | Specifies the Security Policy that should be assigned to the ALB. | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_ssl_redirect"></a> [ssl\_redirect](#input\_ssl\_redirect) | Redirects HTTP traffic into HTTPs if set true. | `bool` | `true` | no |
| <a name="input_tls_hosts"></a> [tls\_hosts](#input\_tls\_hosts) | Hosts are a list of hosts included in the TLS certificate. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_annotations"></a> [annotations](#output\_annotations) | Ingress resource's annotations. |
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | The Ingress group name. |
| <a name="output_name"></a> [name](#output\_name) | The name of Ingress. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
