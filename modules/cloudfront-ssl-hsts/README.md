# example with ALB default and 2 more cache behaviors:

```hcl
provider "aws" {
  region = "us-east-1"
}

module "cdn" {
  source = "dasmeta/modules/aws//modules/cloudfront-ssl-hsts"
  version = "0.19.5"

  zone    = ["devops.dasmeta.com"]
  aliases = ["cdn.devops.dasmeta.com"]
  comment             = "My CloudFront"
  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "My awesome CloudFront can access"
  }

  logging_config = {
    bucket = "logs-my-cdn.s3.amazonaws.com"
  }

  origin = {
    something = {
      domain_name = "something.example.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }

    s3_one = {
      domain_name = "my-s3-bycket.s3.amazonaws.com"
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id           = "alb"
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/alb"
      target_origin_id       = "alb"
    },
    {
      path_pattern           = "/alb2"
      target_origin_id       = "alb"
    }
  ]

}
```

# sample with S3 default cache behavior

```hcl
provider "aws" {
 region = "us-east-1"
}

module "cdn" {
 source = "dasmeta/modules/aws//modules/cloudfront-ssl-hsts"
 version = "0.19.5"

 zone    = ["devops.dasmeta.com"]
 aliases = ["cdn.devops.dasmeta.com"]
 comment = "My CloudFront"

 origin = {
   s3 = {
     domain_name = "S3 website URL" # you need to enable S3 website to have this
     custom_origin_config = {
       origin_protocol_policy = "http-only"
     }
   }
 }

 default_cache_behavior = {
   target_origin_id = "s3"
   use_forwarded_values = true
   headers = [] # the default value is ["*"] and S3 origin do not support it, so we just need to disable it
 }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 3.64   |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 3.64 |

## Modules

| Name                                                                                                                             | Source                                                       | Version |
| -------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------ | ------- |
| <a name="module_aws-cloudfront-security-headers"></a> [aws-cloudfront-security-headers](#module_aws-cloudfront-security-headers) | dasmeta/modules/aws//modules/aws-cloudfront-security-headers | 0.23.1  |
| <a name="module_ssl-certificate-auth"></a> [ssl-certificate-auth](#module_ssl-certificate-auth)                                  | dasmeta/modules/aws//modules/ssl-certificate                 | 0.17.1  |

## Resources

| Name                                                                                                                                                          | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)                       | resource |
| [aws_cloudfront_monitoring_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_monitoring_subscription) | resource |
| [aws_cloudfront_origin_access_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity)   | resource |

## Inputs

| Name                                                                                                                                          | Description                                                                                                                                                                                                                                                                                                                                 | Type           | Default                                                                                                       | Required |
| --------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ------------------------------------------------------------------------------------------------------------- | :------: |
| <a name="input_aliases"></a> [aliases](#input_aliases)                                                                                        | Extra CNAMEs (alternate domain names), if any, for this distribution.                                                                                                                                                                                                                                                                       | `list(string)` | n/a                                                                                                           |   yes    |
| <a name="input_comment"></a> [comment](#input_comment)                                                                                        | Any comments you want to include about the distribution.                                                                                                                                                                                                                                                                                    | `string`       | `null`                                                                                                        |    no    |
| <a name="input_create_certificate"></a> [create_certificate](#input_create_certificate)                                                       | create certificate                                                                                                                                                                                                                                                                                                                          | `bool`         | `true`                                                                                                        |    no    |
| <a name="input_create_distribution"></a> [create_distribution](#input_create_distribution)                                                    | Controls if CloudFront distribution should be created                                                                                                                                                                                                                                                                                       | `bool`         | `true`                                                                                                        |    no    |
| <a name="input_create_hsts"></a> [create_hsts](#input_create_hsts)                                                                            | create hsts                                                                                                                                                                                                                                                                                                                                 | `bool`         | `true`                                                                                                        |    no    |
| <a name="input_create_monitoring_subscription"></a> [create_monitoring_subscription](#input_create_monitoring_subscription)                   | If enabled, the resource for monitoring subscription will created.                                                                                                                                                                                                                                                                          | `bool`         | `false`                                                                                                       |    no    |
| <a name="input_create_origin_access_identity"></a> [create_origin_access_identity](#input_create_origin_access_identity)                      | Controls if CloudFront origin access identity should be created                                                                                                                                                                                                                                                                             | `bool`         | `false`                                                                                                       |    no    |
| <a name="input_custom_error_response"></a> [custom_error_response](#input_custom_error_response)                                              | One or more custom error response elements                                                                                                                                                                                                                                                                                                  | `any`          | `{}`                                                                                                          |    no    |
| <a name="input_default_cache_behavior"></a> [default_cache_behavior](#input_default_cache_behavior)                                           | The default cache behavior for this distribution                                                                                                                                                                                                                                                                                            | `any`          | `null`                                                                                                        |    no    |
| <a name="input_default_root_object"></a> [default_root_object](#input_default_root_object)                                                    | The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL.                                                                                                                                                                                                                             | `string`       | `null`                                                                                                        |    no    |
| <a name="input_enabled"></a> [enabled](#input_enabled)                                                                                        | Whether the distribution is enabled to accept end user requests for content.                                                                                                                                                                                                                                                                | `bool`         | `true`                                                                                                        |    no    |
| <a name="input_geo_restriction"></a> [geo_restriction](#input_geo_restriction)                                                                | The restriction configuration for this distribution (geo_restrictions)                                                                                                                                                                                                                                                                      | `any`          | `{}`                                                                                                          |    no    |
| <a name="input_http_version"></a> [http_version](#input_http_version)                                                                         | The maximum HTTP version to support on the distribution. Allowed values are http1.1 and http2. The default is http2.                                                                                                                                                                                                                        | `string`       | `"http2"`                                                                                                     |    no    |
| <a name="input_is_ipv6_enabled"></a> [is_ipv6_enabled](#input_is_ipv6_enabled)                                                                | Whether the IPv6 is enabled for the distribution.                                                                                                                                                                                                                                                                                           | `bool`         | `true`                                                                                                        |    no    |
| <a name="input_logging_config"></a> [logging_config](#input_logging_config)                                                                   | The logging configuration that controls how logs are written to your distribution (maximum one).                                                                                                                                                                                                                                            | `any`          | `{}`                                                                                                          |    no    |
| <a name="input_ordered_cache_behavior"></a> [ordered_cache_behavior](#input_ordered_cache_behavior)                                           | An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0.                                                                                                                                                                       | `any`          | `[]`                                                                                                          |    no    |
| <a name="input_origin"></a> [origin](#input_origin)                                                                                           | One or more origins for this distribution (multiples allowed).                                                                                                                                                                                                                                                                              | `any`          | `null`                                                                                                        |    no    |
| <a name="input_origin_access_identities"></a> [origin_access_identities](#input_origin_access_identities)                                     | Map of CloudFront origin access identities (value as a comment)                                                                                                                                                                                                                                                                             | `map(string)`  | `{}`                                                                                                          |    no    |
| <a name="input_origin_group"></a> [origin_group](#input_origin_group)                                                                         | One or more origin_group for this distribution (multiples allowed).                                                                                                                                                                                                                                                                         | `any`          | `{}`                                                                                                          |    no    |
| <a name="input_override_custom_headers"></a> [override_custom_headers](#input_override_custom_headers)                                        | Allows to override-default/disable-default/have-additional security headers                                                                                                                                                                                                                                                                 | `any`          | `{}`                                                                                                          |    no    |
| <a name="input_price_class"></a> [price_class](#input_price_class)                                                                            | The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100                                                                                                                                                                                                                                                | `string`       | `"PriceClass_All"`                                                                                            |    no    |
| <a name="input_realtime_metrics_subscription_status"></a> [realtime_metrics_subscription_status](#input_realtime_metrics_subscription_status) | A flag that indicates whether additional CloudWatch metrics are enabled for a given CloudFront distribution. Valid values are `Enabled` and `Disabled`.                                                                                                                                                                                     | `string`       | `"Enabled"`                                                                                                   |    no    |
| <a name="input_retain_on_delete"></a> [retain_on_delete](#input_retain_on_delete)                                                             | Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards.                                                                                                                                                                  | `bool`         | `false`                                                                                                       |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                                 | A map of tags to assign to the resource.                                                                                                                                                                                                                                                                                                    | `map(string)`  | `null`                                                                                                        |    no    |
| <a name="input_viewer_certificate"></a> [viewer_certificate](#input_viewer_certificate)                                                       | The SSL configuration for this distribution                                                                                                                                                                                                                                                                                                 | `any`          | <pre>{<br> "cloudfront_default_certificate": false,<br> "minimum_protocol_version": "TLSv1.2_2021"<br>}</pre> |    no    |
| <a name="input_wait_for_deployment"></a> [wait_for_deployment](#input_wait_for_deployment)                                                    | If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this tofalse will skip the process.                                                                                                                                                                                           | `bool`         | `false`                                                                                                       |    no    |
| <a name="input_web_acl_id"></a> [web_acl_id](#input_web_acl_id)                                                                               | If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL. | `string`       | `null`                                                                                                        |    no    |
| <a name="input_zone"></a> [zone](#input_zone)                                                                                                 | domen zones.                                                                                                                                                                                                                                                                                                                                | `list(string)` | n/a                                                                                                           |   yes    |

## Outputs

| Name                                                                                                                                                                                                  | Description                                                                                                                                     |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront_distribution_arn](#output_cloudfront_distribution_arn)                                                                                  | The ARN (Amazon Resource Name) for the distribution.                                                                                            |
| <a name="output_cloudfront_distribution_caller_reference"></a> [cloudfront_distribution_caller_reference](#output_cloudfront_distribution_caller_reference)                                           | Internal value used by CloudFront to allow future updates to the distribution configuration.                                                    |
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront_distribution_domain_name](#output_cloudfront_distribution_domain_name)                                                          | The domain name corresponding to the distribution.                                                                                              |
| <a name="output_cloudfront_distribution_etag"></a> [cloudfront_distribution_etag](#output_cloudfront_distribution_etag)                                                                               | The current version of the distribution's information.                                                                                          |
| <a name="output_cloudfront_distribution_hosted_zone_id"></a> [cloudfront_distribution_hosted_zone_id](#output_cloudfront_distribution_hosted_zone_id)                                                 | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to.                                                      |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront_distribution_id](#output_cloudfront_distribution_id)                                                                                     | The identifier for the distribution.                                                                                                            |
| <a name="output_cloudfront_distribution_in_progress_validation_batches"></a> [cloudfront_distribution_in_progress_validation_batches](#output_cloudfront_distribution_in_progress_validation_batches) | The number of invalidation batches currently in progress.                                                                                       |
| <a name="output_cloudfront_distribution_last_modified_time"></a> [cloudfront_distribution_last_modified_time](#output_cloudfront_distribution_last_modified_time)                                     | The date and time the distribution was last modified.                                                                                           |
| <a name="output_cloudfront_distribution_status"></a> [cloudfront_distribution_status](#output_cloudfront_distribution_status)                                                                         | The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system. |
| <a name="output_cloudfront_distribution_trusted_signers"></a> [cloudfront_distribution_trusted_signers](#output_cloudfront_distribution_trusted_signers)                                              | List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs                   |
| <a name="output_cloudfront_monitoring_subscription_id"></a> [cloudfront_monitoring_subscription_id](#output_cloudfront_monitoring_subscription_id)                                                    | The ID of the CloudFront monitoring subscription, which corresponds to the `distribution_id`.                                                   |
| <a name="output_cloudfront_origin_access_identities"></a> [cloudfront_origin_access_identities](#output_cloudfront_origin_access_identities)                                                          | The origin access identities created                                                                                                            |
| <a name="output_cloudfront_origin_access_identity_iam_arns"></a> [cloudfront_origin_access_identity_iam_arns](#output_cloudfront_origin_access_identity_iam_arns)                                     | The IAM arns of the origin access identities created                                                                                            |
| <a name="output_cloudfront_origin_access_identity_ids"></a> [cloudfront_origin_access_identity_ids](#output_cloudfront_origin_access_identity_ids)                                                    | The IDS of the origin access identities created                                                                                                 |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
