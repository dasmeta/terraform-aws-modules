## Minimum usage example

This example creates clodufront setup with a default origin only and uses S3 bucket. Also it has no custom certiifcate, as the `use_default_cert = true`.

```
module "cf" {
    source = "dasmeta/modules/aws//modules/cloudfront"
    origins = [
        {
          target = "some-s3-bucket-name.s3.us-east-1.amazonaws.com"
          type = "bucket"
          custom_origin_config = []
        }
    ]
    use_default_cert = true
    default_target_origin_id = "some-s3-bucket-name.s3.us-east-1.amazonaws.com"
    domain_names = ["example.com"]
}
```

## example using AWS origin access control

```
module "cf" {
    source = "dasmeta/modules/aws//modules/cloudfront"
    origins = [
        {
          target = "some-s3-bucket-name.s3.us-east-1.amazonaws.com"
          type = "bucket"
          origin_access_control_id = aws_cloudfront_origin_access_control.some.id
          custom_origin_config = []
        }
    ]
    use_default_cert = true
    default_target_origin_id = "some-s3-bucket-name.s3.us-east-1.amazonaws.com"
    domain_names = ["example.com"]
}

resource "aws_cloudfront_origin_access_control" "some" {
  name                              = "access_some_s3_bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
```


## example to create cloudfront and enable security headers lambda and set custom certificate

```
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

data "aws_s3_bucket" "selected" {
  bucket = "devops.dasmeta.com"

  provider = aws.virginia
}

data "aws_acm_certificate" "issued" {
  domain   = "devops.dasmeta.com"
  statuses = ["ISSUED"]

  provider = aws.virginia
}

module test-cloudfront {
  source = "dasmeta/modules/aws//modules/cloudfront"
  origins = [
      {
        target = data.aws_s3_bucket.selected.bucket_regional_domain_name
        type = "bucket"
        custom_origin_config = []
      }
  ]
  logging_config = {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  }

  acm_cert_arn = data.aws_acm_certificate.issued.arn
  create_lambda_security_headers = true
  default_target_origin_id = data.aws_s3_bucket.selected.bucket_regional_domain_name
  domain_names = ["devops.dasmeta.com"]
}
```

## Another usage example

This example creates other origins except the default origin and uses not only s3, but also load balancers to do it. In the `origin` block you need to specify the type of the target for each item. There are 2 types: "alb", "bucket". Also if you want to create lambda function for security headers, set `create_lambda_security_headers = true`.

```
module "cloudfront" {
    source      = "dasmeta/modules/aws//modules/cloudfront"
    origins = [
        {
          target = "some-elb.eu-central-1.elb.amazonaws.com"
          type = "alb",
          custom_origin_config = [{
              http_port                = 80
              https_port               = 443
              origin_keepalive_timeout = 5
              origin_protocol_policy   = "http-only"
              origin_read_timeout      = 30
              origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
          }]
        },
        {
          target = "some-bucket.s3.eu-central-1.amazonaws.com"
          type = "bucket"
          custom_origin_config = []
        }
    ]
    targets =  [
      {
          target = "some-bucket.s3.eu-central-1.amazonaws.com"
          pattern = "/index.html"
      },
      {
          target = "some-bucket.s3.eu-central-1.amazonaws.com"
          pattern = "/static/*"
      },
      {
          target = "some-elb.eu-central-1.elb.amazonaws.com"
          pattern = "/"
      }
    ]
    acm_cert_arn = "some arn"
    create_lambda_security_headers = true
    default_target_origin_id = "some-default-elb.eu-central-1.elb.amazonaws.com"
    domain_names = ["example.com"]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.50 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.50 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws-cloudfront-security-headers"></a> [aws-cloudfront-security-headers](#module\_aws-cloudfront-security-headers) | ../aws-cloudfront-security-headers | n/a |
| <a name="module_aws-cloudfront-security-headers-policy"></a> [aws-cloudfront-security-headers-policy](#module\_aws-cloudfront-security-headers-policy) | ./modules/response_headers/ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_cert_arn"></a> [acm\_cert\_arn](#input\_acm\_cert\_arn) | ACM certificate arn. | `string` | `""` | no |
| <a name="input_cache_policy_id"></a> [cache\_policy\_id](#input\_cache\_policy\_id) | Unique identifier of the cache policy that is attached to the cache behavior | `string` | `""` | no |
| <a name="input_cloudfront_default_certificate"></a> [cloudfront\_default\_certificate](#input\_cloudfront\_default\_certificate) | true if you want viewers to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution. | `bool` | `true` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Comment for CloudFront | `string` | `""` | no |
| <a name="input_connection_attempts"></a> [connection\_attempts](#input\_connection\_attempts) | The number of times that CloudFront attempts to connect to the origin. | `number` | `3` | no |
| <a name="input_connection_timeout"></a> [connection\_timeout](#input\_connection\_timeout) | The number of seconds that CloudFront waits when trying to establish a connection to the origin. | `number` | `10` | no |
| <a name="input_create_lambda_security_headers"></a> [create\_lambda\_security\_headers](#input\_create\_lambda\_security\_headers) | Whether to create and attach a labda function to the distribution or not. | `bool` | `false` | no |
| <a name="input_create_response_headers_policy"></a> [create\_response\_headers\_policy](#input\_create\_response\_headers\_policy) | n/a | <pre>object({<br>    enabled = optional(bool, false)<br>    name    = optional(string, "custome_response_headers")<br>    security_headers = object({<br>      frame_options = optional(string)<br>    })<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "name": "custome_response_headers",<br>  "security_headers": {}<br>}</pre> | no |
| <a name="input_custom_origin_config"></a> [custom\_origin\_config](#input\_custom\_origin\_config) | n/a | `map` | <pre>{<br>  "http_port": 80,<br>  "https_port": 443,<br>  "origin_keepalive_timeout": 5,<br>  "origin_protocol_policy": "http-only",<br>  "origin_read_timeout": 30,<br>  "origin_ssl_protocols": [<br>    "TLSv1",<br>    "TLSv1.1",<br>    "TLSv1.2"<br>  ]<br>}</pre> | no |
| <a name="input_default_allowed_methods"></a> [default\_allowed\_methods](#input\_default\_allowed\_methods) | Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin. | `list(string)` | <pre>[<br>  "DELETE",<br>  "GET",<br>  "HEAD",<br>  "OPTIONS",<br>  "PATCH",<br>  "POST",<br>  "PUT"<br>]</pre> | no |
| <a name="input_default_cached_methods"></a> [default\_cached\_methods](#input\_default\_cached\_methods) | Controls whether CloudFront caches the response to requests using the specified HTTP methods. | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| <a name="input_default_compress"></a> [default\_compress](#input\_default\_compress) | Whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header. | `bool` | `true` | no |
| <a name="input_default_default_ttl"></a> [default\_default\_ttl](#input\_default\_default\_ttl) | The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header. | `number` | `0` | no |
| <a name="input_default_max_ttl"></a> [default\_max\_ttl](#input\_default\_max\_ttl) | The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. | `number` | `0` | no |
| <a name="input_default_min_ttl"></a> [default\_min\_ttl](#input\_default\_min\_ttl) | The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. | `number` | `0` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL. | `string` | `"index.html"` | no |
| <a name="input_default_smooth_streaming"></a> [default\_smooth\_streaming](#input\_default\_smooth\_streaming) | Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior. | `bool` | `false` | no |
| <a name="input_default_target_origin_id"></a> [default\_target\_origin\_id](#input\_default\_target\_origin\_id) | The value of ID for the origin that you want CloudFront to route requests to when a request matches the path pattern either for a cache behavior or for the default cache behavior. | `string` | n/a | yes |
| <a name="input_default_viewer_protocol_policy"></a> [default\_viewer\_protocol\_policy](#input\_default\_viewer\_protocol\_policy) | Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https. | `string` | `"allow-all"` | no |
| <a name="input_domain_names"></a> [domain\_names](#input\_domain\_names) | The list of domain names (aliases) for which cloudfront will used for | `list(string)` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the distribution is enabled to accept end user requests for content. | `bool` | `true` | no |
| <a name="input_forwarded_values"></a> [forwarded\_values](#input\_forwarded\_values) | Origin Forwarded value | <pre>object({<br>    query_string = optional(bool, false)<br>    headers      = optional(list(string), ["Origin"])<br>    forward      = optional(string, "none")<br>  })</pre> | <pre>{<br>  "forward": "none",<br>  "headers": [<br>    "Origin"<br>  ],<br>  "query_string": false<br>}</pre> | no |
| <a name="input_function_associations"></a> [function\_associations](#input\_function\_associations) | A list of Cloudfront function associations. | <pre>list(object({<br>    event_type   = string<br>    function_arn = string<br>  }))</pre> | `[]` | no |
| <a name="input_http_port"></a> [http\_port](#input\_http\_port) | The HTTP port the custom origin listens on. | `number` | `80` | no |
| <a name="input_https_port"></a> [https\_port](#input\_https\_port) | The HTTPS port the custom origin listens on. | `number` | `443` | no |
| <a name="input_is_ipv6_enabled"></a> [is\_ipv6\_enabled](#input\_is\_ipv6\_enabled) | Whether the IPv6 is enabled for the distribution. | `bool` | `true` | no |
| <a name="input_lambda_function_body"></a> [lambda\_function\_body](#input\_lambda\_function\_body) | When set to true it exposes the request body to the lambda function. Valid values: true, false. | `bool` | `false` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | n/a | <pre>object({<br>    enabled         = optional(bool, false)<br>    bucket          = string<br>    prefix          = optional(string, "/")<br>    include_cookies = optional(bool, false)<br>  })</pre> | <pre>{<br>  "bucket": null,<br>  "enable": false<br>}</pre> | no |
| <a name="input_minimum_protocol_version"></a> [minimum\_protocol\_version](#input\_minimum\_protocol\_version) | The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. | `string` | `"TLSv1"` | no |
| <a name="input_ordered_allowed_methods"></a> [ordered\_allowed\_methods](#input\_ordered\_allowed\_methods) | n/a | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD",<br>  "OPTIONS"<br>]</pre> | no |
| <a name="input_ordered_cached_methods"></a> [ordered\_cached\_methods](#input\_ordered\_cached\_methods) | n/a | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| <a name="input_ordered_compress"></a> [ordered\_compress](#input\_ordered\_compress) | n/a | `bool` | `true` | no |
| <a name="input_ordered_default_ttl"></a> [ordered\_default\_ttl](#input\_ordered\_default\_ttl) | n/a | `number` | `0` | no |
| <a name="input_ordered_max_ttl"></a> [ordered\_max\_ttl](#input\_ordered\_max\_ttl) | n/a | `number` | `0` | no |
| <a name="input_ordered_min_ttl"></a> [ordered\_min\_ttl](#input\_ordered\_min\_ttl) | n/a | `number` | `0` | no |
| <a name="input_ordered_smooth_streaming"></a> [ordered\_smooth\_streaming](#input\_ordered\_smooth\_streaming) | n/a | `bool` | `false` | no |
| <a name="input_ordered_viewer_protocol_policy"></a> [ordered\_viewer\_protocol\_policy](#input\_ordered\_viewer\_protocol\_policy) | n/a | `string` | `"redirect-to-https"` | no |
| <a name="input_origin_keepalive_timeout"></a> [origin\_keepalive\_timeout](#input\_origin\_keepalive\_timeout) | The Custom KeepAlive timeout, in seconds. | `number` | `5` | no |
| <a name="input_origin_protocol_policy"></a> [origin\_protocol\_policy](#input\_origin\_protocol\_policy) | The origin protocol policy to apply to your origin. | `string` | `"http-only"` | no |
| <a name="input_origin_read_timeout"></a> [origin\_read\_timeout](#input\_origin\_read\_timeout) | The Custom Read timeout, in seconds. | `number` | `30` | no |
| <a name="input_origin_ssl_protocols"></a> [origin\_ssl\_protocols](#input\_origin\_ssl\_protocols) | The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. | `list(string)` | <pre>[<br>  "TLSv1",<br>  "TLSv1.1",<br>  "TLSv1.2"<br>]</pre> | no |
| <a name="input_origins"></a> [origins](#input\_origins) | Targets, types and custom\_origin\_config block are needed to create new origins. | `list(any)` | n/a | yes |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | The price class for this distribution. | `string` | `"PriceClass_All"` | no |
| <a name="input_response_headers_policy_id"></a> [response\_headers\_policy\_id](#input\_response\_headers\_policy\_id) | Identifier for a response headers policy. | `string` | `null` | no |
| <a name="input_restriction_type"></a> [restriction\_type](#input\_restriction\_type) | The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist. | `string` | `"none"` | no |
| <a name="input_retain_on_delete"></a> [retain\_on\_delete](#input\_retain\_on\_delete) | Disables the distribution instead of deleting it when destroying the resource through Terraform. | `bool` | `false` | no |
| <a name="input_tags_name"></a> [tags\_name](#input\_tags\_name) | n/a | `string` | `"terraform testing"` | no |
| <a name="input_targets"></a> [targets](#input\_targets) | Targets and patterns needed to create new behaviours. | `list(any)` | `[]` | no |
| <a name="input_use_default_cert"></a> [use\_default\_cert](#input\_use\_default\_cert) | Whether to use custom or default certificate. | `bool` | `false` | no |
| <a name="input_wait_for_deployment"></a> [wait\_for\_deployment](#input\_wait\_for\_deployment) | If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_distribution_id"></a> [distribution\_id](#output\_distribution\_id) | CDN distribution id to be used with AWS CLI or API calls. |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | CDN domain name to be aliasd in Route53 or used somewhere else. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | CDN hosted zone id to be aliasd in Route53 or used somewhere else. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
