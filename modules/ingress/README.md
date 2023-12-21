# Module setup ingress controller.

## Problem
When creating R53 records or CDN origins we need to explicitly pass ALB's DNS name to those resources. It's not convenient and not flexible.
Besides, there may be multiple ingresses each of which can create an ALB, but this is expensive.

## Solution
The main purpose of `ingress` module is to manage ingress resource from Terraform but edit/use/configure it from k8s side.
We recommend to use this Terraform module. In the result of this you can:
1. manage the state of the resource by Terraform,
2. by setting `alb.ingress.kubernetes.io/group.name` annotation attach multiple ingresses to the main one created by the module and use just one ALB,
3. manage all the Ingress rules from the application side.

# Example. Create ingress with an existing certificate, host and custom values for ingress annotations

## Usage

```bash
$ terraform init
$ terraform plan
$ terraform apply
$ kubectl apply -f ingress.yaml
```

```terraform
data "aws_acm_certificate" "issued" {
  domain   = "dasmeta.com"
  statuses = ["ISSUED"]
}

module "ingress" {
  source = "dasmeta/modules/aws//modules/ingress"

  name     = "terraform-ingress"
  hostname = "dasmeta.com"

  certificate_arn           = data.aws_acm_certificate.issued.arn
  healthcheck_path          = "/health"
  healthcheck_success_codes = "200-399"

  tls_hosts = "dasmeta.com"
}

module "route53" {
  source  = "dasmeta/modules/aws//modules/route53"
  version = "0.21.17"

  zone        = "example.com"
  create_zone = false
  records = [
    {
      name  = "test1.example.com"
      type  = "A"
      value = [module.ingress.ingress_hostname]
    }
  ]
  ttl = "30"

  depends_on = [
    module.ingress
  ]
}
```

`ingress.yaml`
```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  namespace: default
  name: ingress
  annotations:
      alb.ingress.kubernetes.io/group.name: test-ingress,
      kubernetes.io/ingress.class: alb,
spec:
  rules:
    - http:
        paths:
          - path: /welcome
            backend:
              serviceName: myapp1
              servicePort: 80
          - path: /bye
            backend:
              serviceName: myapp2
              servicePort: 8088
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb-to-cloudwatch"></a> [alb-to-cloudwatch](#module\_alb-to-cloudwatch) | dasmeta/modules/aws//modules/alb-logs-to-s3-to-cloudwatch | 2.9.2 |
| <a name="module_cw_alerts"></a> [cw\_alerts](#module\_cw\_alerts) | dasmeta/monitoring/aws//modules/alerts | 1.3.5 |

## Resources

| Name | Type |
|------|------|
| [kubernetes_ingress_v1.this_v1](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [null_resource.previous](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [time_sleep.wait_30_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_lb.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [kubernetes_ingress_v1.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/ingress_v1) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarms"></a> [alarms](#input\_alarms) | Alarms for ALB | <pre>object({<br>    enabled       = optional(bool, true)<br>    sns_topic     = string<br>    custom_values = optional(any, {})<br>  })</pre> | n/a | yes |
| <a name="input_backend_protocol"></a> [backend\_protocol](#input\_backend\_protocol) | Specifies the protocol used when route traffic to pods. | `string` | `"HTTP"` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | Specifies the ARN of one or more certificate managed by AWS Certificate Manager. If the alb.ingress.kubernetes.io/certificate-arn annotation is not specified, the controller will attempt to add certificates to listeners that require it by matching available certs from ACM with the host field in each listener's ingress rule. | `string` | `""` | no |
| <a name="input_default_backend"></a> [default\_backend](#input\_default\_backend) | n/a | <pre>object({<br>    service_name = string<br>    service_port = string<br>  })</pre> | <pre>{<br>  "service_name": null,<br>  "service_port": null<br>}</pre> | no |
| <a name="input_enable_send_alb_logs_to_cloudwatch"></a> [enable\_send\_alb\_logs\_to\_cloudwatch](#input\_enable\_send\_alb\_logs\_to\_cloudwatch) | Send ALB logs to Cloudwatch | `bool` | `false` | no |
| <a name="input_healthcheck_path"></a> [healthcheck\_path](#input\_healthcheck\_path) | Specifies the HTTP path when performing health check on targets. | `string` | `"/"` | no |
| <a name="input_healthcheck_success_codes"></a> [healthcheck\_success\_codes](#input\_healthcheck\_success\_codes) | Specifies the HTTP status code that should be expected when doing health checks against the specified health check path. | `string` | `"200-399"` | no |
| <a name="input_hostnames"></a> [hostnames](#input\_hostnames) | Host is the fully qualified domain name of a network host. | `list(string)` | `null` | no |
| <a name="input_load_balancer_attributes"></a> [load\_balancer\_attributes](#input\_load\_balancer\_attributes) | Specifies Load Balancer Attributes that should be applied to the ALB. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Ingress, must be unique. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | K8s namespace where the Ingress will be created. | `string` | `"default"` | no |
| <a name="input_path"></a> [path](#input\_path) | Path array of path regex associated with a backend. Incoming urls matching the path are forwarded to the backend. | <pre>list(object({<br>    name = string<br>    port = string<br>    path = string<br>  }))</pre> | `null` | no |
| <a name="input_scheme"></a> [scheme](#input\_scheme) | Specifies whether your LoadBalancer will be internet facing. | `string` | `"internet-facing"` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | Specifies the Security Policy that should be assigned to the ALB. | `string` | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| <a name="input_ssl_redirect"></a> [ssl\_redirect](#input\_ssl\_redirect) | Redirects HTTP traffic into HTTPs if set true. | `bool` | `true` | no |
| <a name="input_tls_hosts"></a> [tls\_hosts](#input\_tls\_hosts) | Hosts are a list of hosts included in the TLS certificate. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_annotations"></a> [annotations](#output\_annotations) | Ingress resource's annotations. |
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | The Ingress group name. |
| <a name="output_ingress_all"></a> [ingress\_all](#output\_ingress\_all) | Load Balancer all info. |
| <a name="output_ingress_hostname"></a> [ingress\_hostname](#output\_ingress\_hostname) | Load Balancer DNS name. |
| <a name="output_ingress_zone_id"></a> [ingress\_zone\_id](#output\_ingress\_zone\_id) | Load Balancer all info. |
| <a name="output_name"></a> [name](#output\_name) | The name of Ingress. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
