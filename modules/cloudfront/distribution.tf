locals {
  targets =  var.targets
}

locals {
  origins =  var.origins
}

locals {
  use_default_cert = var.use_default_cert
}

locals {
  viewer_certificates = [
    {
      acm_certificate_arn            = local.use_default_cert ? null : var.acm_cert_arn
      minimum_protocol_version       = local.use_default_cert ? null : "TLSv1.2_2021"
      ssl_support_method             = local.use_default_cert ? null : "sni-only"
      cloudfront_default_certificate = local.use_default_cert
    },
  ]
}

# module "ssl-cert" {
#   source = "../aws-ssl-certificate"
#   region = "us-east-1"
#   domain = var.domain
# }

resource "aws_cloudfront_distribution" "von-poll" {
    enabled                        = var.enabled
    is_ipv6_enabled                = var.is_ipv6_enabled
    price_class                    = var.price_class
    retain_on_delete               = var.retain_on_delete

    tags                           = {
     Name = var.tags_name
    }
 
    wait_for_deployment            = var.wait_for_deployment

    default_cache_behavior {
        allowed_methods        = var.ordered_allowed_methods_1
        cached_methods         = var.ordered_cached_methods_1
        compress               = var.ordered_compress_1
        default_ttl            = var.ordered_default_ttl_1

        forwarded_values {
          query_string = false
          headers      = ["Origin"]

          cookies {
            forward = "none"
          }
        }

        max_ttl                = var.ordered_max_ttl_1
        min_ttl                = var.ordered_min_ttl_1
        smooth_streaming       = var.ordered_smooth_streaming_1
        target_origin_id       = var.default_target_origin_id
        viewer_protocol_policy = var.ordered_viewer_protocol_policy_1
    }

    dynamic "ordered_cache_behavior" {
      for_each = local.targets

      content {
        allowed_methods        = var.ordered_allowed_methods_2
        cached_methods         = var.ordered_cached_methods_2
        compress               = var.ordered_compress_2
        default_ttl            = var.ordered_default_ttl_2
        max_ttl                = var.ordered_max_ttl_2

        forwarded_values {
          query_string = false
          headers      = ["Origin"]

          cookies {
            forward = "none"
          }
        }

        min_ttl                = var.ordered_min_ttl_2
        path_pattern           = ordered_cache_behavior.value.pattern
        smooth_streaming       = var.ordered_smooth_streaming_2
        target_origin_id       = ordered_cache_behavior.value.target
        viewer_protocol_policy = var.ordered_viewer_protocol_policy_2
      }
    }

    dynamic "origin" {
      for_each = local.origins

      content {
        connection_attempts  = var.connection_attempts_1
        connection_timeout   = var.connection_timeout_1
        domain_name          = origin.value.target
        origin_id            = origin.value.target

        dynamic "custom_origin_config" {
            for_each = origin.value.custom_origin_config

            content {
              http_port                = custom_origin_config.value.http_port
              https_port               = custom_origin_config.value.https_port
              origin_keepalive_timeout = custom_origin_config.value.origin_keepalive_timeout
              origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
              origin_read_timeout      = custom_origin_config.value.origin_read_timeout
              origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
            }
        }
      }
    }

    restrictions {
        geo_restriction {
            restriction_type = var.restriction_type
        }
    }

    # viewer_certificate {
    #     cloudfront_default_certificate = var.cloudfront_default_certificate
    #     minimum_protocol_version       = var.minimum_protocol_version
    # }

   dynamic "viewer_certificate" {
    for_each = local.viewer_certificates
    content {
      acm_certificate_arn            = viewer_certificate.value.acm_certificate_arn
      minimum_protocol_version       = viewer_certificate.value.minimum_protocol_version
      ssl_support_method             = viewer_certificate.value.ssl_support_method
      cloudfront_default_certificate = viewer_certificate.value.cloudfront_default_certificate
    }
  }
}
