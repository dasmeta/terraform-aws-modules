# response_headers

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_response_headers_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_response_headers_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_headers"></a> [custom\_headers](#input\_custom\_headers) | List of custom headers with header name, value, and override flag | <pre>list(object({<br>    header   = string<br>    value    = string<br>    override = bool<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Cloudfront response headers polic | `string` | n/a | yes |
| <a name="input_security_headers"></a> [security\_headers](#input\_security\_headers) | n/a | <pre>object({<br>    frame_options = optional(string)<br>  })</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
