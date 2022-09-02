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

| Name                                                   | Version |
| ------------------------------------------------------ | ------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | ~> 3.43 |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | ~> 3.43 |

## Modules

| Name                                                                                                                             | Source                             | Version |
| -------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- | ------- |
| <a name="module_aws-cloudfront-security-headers"></a> [aws-cloudfront-security-headers](#module_aws-cloudfront-security-headers) | ../aws-cloudfront-security-headers | n/a     |

## Resources

| Name                                                                                                                                    | Type     |
| --------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_cloudfront_distribution.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |

## Inputs

| Name                                                                                                                        | Description                                                                                                                                                                                                                           | Type           | Default                                                                                                                                                                                                                                                  | Required |
| --------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------: |
| <a name="input_acm_cert_arn"></a> [acm_cert_arn](#input_acm_cert_arn)                                                       | ACM certificate arn.                                                                                                                                                                                                                  | `string`       | `""`                                                                                                                                                                                                                                                     |    no    |
| <a name="input_cloudfront_default_certificate"></a> [cloudfront_default_certificate](#input_cloudfront_default_certificate) | true if you want viewers to use HTTPS to request your objects and you're using the CloudFront domain name for your distribution.                                                                                                      | `bool`         | `true`                                                                                                                                                                                                                                                   |    no    |
| <a name="input_connection_attempts"></a> [connection_attempts](#input_connection_attempts)                                  | The number of times that CloudFront attempts to connect to the origin.                                                                                                                                                                | `number`       | `3`                                                                                                                                                                                                                                                      |    no    |
| <a name="input_connection_timeout"></a> [connection_timeout](#input_connection_timeout)                                     | The number of seconds that CloudFront waits when trying to establish a connection to the origin.                                                                                                                                      | `number`       | `10`                                                                                                                                                                                                                                                     |    no    |
| <a name="input_create_lambda_security_headers"></a> [create_lambda_security_headers](#input_create_lambda_security_headers) | Whether to create and attach a labda function to the distribution or not.                                                                                                                                                             | `bool`         | `false`                                                                                                                                                                                                                                                  |    no    |
| <a name="input_custom_origin_config"></a> [custom_origin_config](#input_custom_origin_config)                               | n/a                                                                                                                                                                                                                                   | `map`          | <pre>{<br> "http_port": 80,<br> "https_port": 443,<br> "origin_keepalive_timeout": 5,<br> "origin_protocol_policy": "http-only",<br> "origin_read_timeout": 30,<br> "origin_ssl_protocols": [<br> "TLSv1",<br> "TLSv1.1",<br> "TLSv1.2"<br> ]<br>}</pre> |    no    |
| <a name="input_default_allowed_methods"></a> [default_allowed_methods](#input_default_allowed_methods)                      | Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin.                                                                                                                         | `list(string)` | <pre>[<br> "DELETE",<br> "GET",<br> "HEAD",<br> "OPTIONS",<br> "PATCH",<br> "POST",<br> "PUT"<br>]</pre>                                                                                                                                                 |    no    |
| <a name="input_default_cached_methods"></a> [default_cached_methods](#input_default_cached_methods)                         | Controls whether CloudFront caches the response to requests using the specified HTTP methods.                                                                                                                                         | `list(string)` | <pre>[<br> "GET",<br> "HEAD"<br>]</pre>                                                                                                                                                                                                                  |    no    |
| <a name="input_default_compress"></a> [default_compress](#input_default_compress)                                           | Whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header.                                                                                              | `bool`         | `true`                                                                                                                                                                                                                                                   |    no    |
| <a name="input_default_default_ttl"></a> [default_default_ttl](#input_default_default_ttl)                                  | The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header.                                              | `number`       | `0`                                                                                                                                                                                                                                                      |    no    |
| <a name="input_default_max_ttl"></a> [default_max_ttl](#input_default_max_ttl)                                              | The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated.                                           | `number`       | `0`                                                                                                                                                                                                                                                      |    no    |
| <a name="input_default_min_ttl"></a> [default_min_ttl](#input_default_min_ttl)                                              | The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated.                                                                       | `number`       | `0`                                                                                                                                                                                                                                                      |    no    |
| <a name="input_default_root_object"></a> [default_root_object](#input_default_root_object)                                  | The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL.                                                                                                                       | `string`       | `""`                                                                                                                                                                                                                                                     |    no    |
| <a name="input_default_smooth_streaming"></a> [default_smooth_streaming](#input_default_smooth_streaming)                   | Indicates whether you want to distribute media files in Microsoft Smooth Streaming format using the origin that is associated with this cache behavior.                                                                               | `bool`         | `false`                                                                                                                                                                                                                                                  |    no    |
| <a name="input_default_target_origin_id"></a> [default_target_origin_id](#input_default_target_origin_id)                   | The value of ID for the origin that you want CloudFront to route requests to when a request matches the path pattern either for a cache behavior or for the default cache behavior.                                                   | `string`       | n/a                                                                                                                                                                                                                                                      |   yes    |
| <a name="input_default_viewer_protocol_policy"></a> [default_viewer_protocol_policy](#input_default_viewer_protocol_policy) | Use this element to specify the protocol that users can use to access the files in the origin specified by TargetOriginId when a request matches the path pattern in PathPattern. One of allow-all, https-only, or redirect-to-https. | `string`       | `"allow-all"`                                                                                                                                                                                                                                            |    no    |
| <a name="input_domain_names"></a> [domain_names](#input_domain_names)                                                       | The list of domain names (aliases) for which cloudfront will used for                                                                                                                                                                 | `list(string)` | n/a                                                                                                                                                                                                                                                      |   yes    |
| <a name="input_enabled"></a> [enabled](#input_enabled)                                                                      | Whether the distribution is enabled to accept end user requests for content.                                                                                                                                                          | `bool`         | `true`                                                                                                                                                                                                                                                   |    no    |
| <a name="input_http_port"></a> [http_port](#input_http_port)                                                                | The HTTP port the custom origin listens on.                                                                                                                                                                                           | `number`       | `80`                                                                                                                                                                                                                                                     |    no    |
| <a name="input_https_port"></a> [https_port](#input_https_port)                                                             | The HTTPS port the custom origin listens on.                                                                                                                                                                                          | `number`       | `443`                                                                                                                                                                                                                                                    |    no    |
| <a name="input_is_ipv6_enabled"></a> [is_ipv6_enabled](#input_is_ipv6_enabled)                                              | Whether the IPv6 is enabled for the distribution.                                                                                                                                                                                     | `bool`         | `true`                                                                                                                                                                                                                                                   |    no    |
| <a name="input_lambda_function_body"></a> [lambda_function_body](#input_lambda_function_body)                               | When set to true it exposes the request body to the lambda function. Valid values: true, false.                                                                                                                                       | `bool`         | `false`                                                                                                                                                                                                                                                  |    no    |
| <a name="input_logging_config"></a> [logging_config](#input_logging_config)                                                 | n/a                                                                                                                                                                                                                                   | `any`          | `{}`                                                                                                                                                                                                                                                     |    no    |
| <a name="input_minimum_protocol_version"></a> [minimum_protocol_version](#input_minimum_protocol_version)                   | The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections.                                                                                                                                        | `string`       | `"TLSv1"`                                                                                                                                                                                                                                                |    no    |
| <a name="input_ordered_allowed_methods"></a> [ordered_allowed_methods](#input_ordered_allowed_methods)                      | n/a                                                                                                                                                                                                                                   | `list(string)` | <pre>[<br> "GET",<br> "HEAD",<br> "OPTIONS"<br>]</pre>                                                                                                                                                                                                   |    no    |
| <a name="input_ordered_cached_methods"></a> [ordered_cached_methods](#input_ordered_cached_methods)                         | n/a                                                                                                                                                                                                                                   | `list(string)` | <pre>[<br> "GET",<br> "HEAD"<br>]</pre>                                                                                                                                                                                                                  |    no    |
| <a name="input_ordered_compress"></a> [ordered_compress](#input_ordered_compress)                                           | n/a                                                                                                                                                                                                                                   | `bool`         | `true`                                                                                                                                                                                                                                                   |    no    |
| <a name="input_ordered_default_ttl"></a> [ordered_default_ttl](#input_ordered_default_ttl)                                  | n/a                                                                                                                                                                                                                                   | `number`       | `0`                                                                                                                                                                                                                                                      |    no    |
| <a name="input_ordered_max_ttl"></a> [ordered_max_ttl](#input_ordered_max_ttl)                                              | n/a                                                                                                                                                                                                                                   | `number`       | `0`                                                                                                                                                                                                                                                      |    no    |
| <a name="input_ordered_min_ttl"></a> [ordered_min_ttl](#input_ordered_min_ttl)                                              | n/a                                                                                                                                                                                                                                   | `number`       | `0`                                                                                                                                                                                                                                                      |    no    |
| <a name="input_ordered_smooth_streaming"></a> [ordered_smooth_streaming](#input_ordered_smooth_streaming)                   | n/a                                                                                                                                                                                                                                   | `bool`         | `false`                                                                                                                                                                                                                                                  |    no    |
| <a name="input_ordered_viewer_protocol_policy"></a> [ordered_viewer_protocol_policy](#input_ordered_viewer_protocol_policy) | n/a                                                                                                                                                                                                                                   | `string`       | `"redirect-to-https"`                                                                                                                                                                                                                                    |    no    |
| <a name="input_origin_keepalive_timeout"></a> [origin_keepalive_timeout](#input_origin_keepalive_timeout)                   | The Custom KeepAlive timeout, in seconds.                                                                                                                                                                                             | `number`       | `5`                                                                                                                                                                                                                                                      |    no    |
| <a name="input_origin_protocol_policy"></a> [origin_protocol_policy](#input_origin_protocol_policy)                         | The origin protocol policy to apply to your origin.                                                                                                                                                                                   | `string`       | `"http-only"`                                                                                                                                                                                                                                            |    no    |
| <a name="input_origin_read_timeout"></a> [origin_read_timeout](#input_origin_read_timeout)                                  | The Custom Read timeout, in seconds.                                                                                                                                                                                                  | `number`       | `30`                                                                                                                                                                                                                                                     |    no    |
| <a name="input_origin_ssl_protocols"></a> [origin_ssl_protocols](#input_origin_ssl_protocols)                               | The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS.                                                                                                                                 | `list(string)` | <pre>[<br> "TLSv1",<br> "TLSv1.1",<br> "TLSv1.2"<br>]</pre>                                                                                                                                                                                              |    no    |
| <a name="input_origins"></a> [origins](#input_origins)                                                                      | Targets, types and custom_origin_config block are needed to create new origins.                                                                                                                                                       | `list(any)`    | n/a                                                                                                                                                                                                                                                      |   yes    |
| <a name="input_price_class"></a> [price_class](#input_price_class)                                                          | The price class for this distribution.                                                                                                                                                                                                | `string`       | `"PriceClass_All"`                                                                                                                                                                                                                                       |    no    |
| <a name="input_restriction_type"></a> [restriction_type](#input_restriction_type)                                           | The method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist.                                                                                                                   | `string`       | `"none"`                                                                                                                                                                                                                                                 |    no    |
| <a name="input_retain_on_delete"></a> [retain_on_delete](#input_retain_on_delete)                                           | Disables the distribution instead of deleting it when destroying the resource through Terraform.                                                                                                                                      | `bool`         | `false`                                                                                                                                                                                                                                                  |    no    |
| <a name="input_tags_name"></a> [tags_name](#input_tags_name)                                                                | n/a                                                                                                                                                                                                                                   | `string`       | `"terraform testing"`                                                                                                                                                                                                                                    |    no    |
| <a name="input_targets"></a> [targets](#input_targets)                                                                      | Targets and patterns needed to create new behaviours.                                                                                                                                                                                 | `list(any)`    | `[]`                                                                                                                                                                                                                                                     |    no    |
| <a name="input_use_default_cert"></a> [use_default_cert](#input_use_default_cert)                                           | Whether to use custom or default certificate.                                                                                                                                                                                         | `bool`         | `false`                                                                                                                                                                                                                                                  |    no    |
| <a name="input_wait_for_deployment"></a> [wait_for_deployment](#input_wait_for_deployment)                                  | If enabled, the resource will wait for the distribution status to change from InProgress to Deployed.                                                                                                                                 | `bool`         | `false`                                                                                                                                                                                                                                                  |    no    |

## Outputs

| Name                                                                          | Description                                                        |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| <a name="output_domain_name"></a> [domain_name](#output_domain_name)          | CDN domain name to be aliasd in Route53 or used somewhere else.    |
| <a name="output_hosted_zone_id"></a> [hosted_zone_id](#output_hosted_zone_id) | CDN hosted zone id to be aliasd in Route53 or used somewhere else. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
