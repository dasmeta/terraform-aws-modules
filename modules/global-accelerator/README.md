# global-accelerator

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | terraform-aws-modules/global-accelerator/aws | 3.0.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the accelerator accepts and routes traffic. | `bool` | `true` | no |
| <a name="input_flow_logs"></a> [flow\_logs](#input\_flow\_logs) | Optional Global Accelerator flow-log delivery configuration for an existing S3 bucket. | <pre>object({<br/>    enabled   = optional(bool, false)<br/>    s3_bucket = optional(string)<br/>    s3_prefix = optional(string)<br/>  })</pre> | <pre>{<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | IP address type for the accelerator. | `string` | `"IPV4"` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | Map of listeners and regional endpoint groups keyed by stable logical names. | <pre>map(object({<br/>    protocol        = optional(string, "TCP")<br/>    client_affinity = optional(string, "NONE")<br/>    port_ranges = list(object({<br/>      from_port = number<br/>      to_port   = number<br/>    }))<br/>    endpoint_groups = map(object({<br/>      endpoint_group_region   = string<br/>      traffic_dial_percentage = optional(number, 100)<br/>      health_check = optional(object({<br/>        protocol         = optional(string, "TCP")<br/>        port             = optional(number)<br/>        path             = optional(string)<br/>        interval_seconds = optional(number, 30)<br/>        threshold_count  = optional(number, 3)<br/>      }), {})<br/>      endpoints = list(object({<br/>        endpoint_id                    = string<br/>        weight                         = optional(number, 128)<br/>        client_ip_preservation_enabled = optional(bool)<br/>      }))<br/>      port_overrides = optional(list(object({<br/>        listener_port = number<br/>        endpoint_port = number<br/>      })), [])<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Global Accelerator. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to supported Global Accelerator resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accelerator_arn"></a> [accelerator\_arn](#output\_accelerator\_arn) | ARN of the Global Accelerator. |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | IPv4 DNS name of the Global Accelerator. |
| <a name="output_dual_stack_dns_name"></a> [dual\_stack\_dns\_name](#output\_dual\_stack\_dns\_name) | Dual Stack DNS name of the Global Accelerator, or null for IPv4-only accelerators. |
| <a name="output_endpoint_group_arns"></a> [endpoint\_group\_arns](#output\_endpoint\_group\_arns) | Endpoint-group ARNs keyed first by listener and then by the original group logical keys. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | Route 53 hosted-zone ID of the Global Accelerator. |
| <a name="output_ip_sets"></a> [ip\_sets](#output\_ip\_sets) | IP address sets assigned to the Global Accelerator. |
| <a name="output_listener_arns"></a> [listener\_arns](#output\_listener\_arns) | Listener ARNs keyed by the original listener logical keys. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
