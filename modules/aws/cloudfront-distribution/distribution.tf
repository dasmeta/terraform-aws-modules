
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
        target_origin_id       = "k8s-vonpolldev-8288e5a5e3-873653782.eu-central-1.elb.amazonaws.com"
        viewer_protocol_policy = var.ordered_viewer_protocol_policy_1
    }

    ordered_cache_behavior {
        allowed_methods        = var.ordered_allowed_methods_1
        cached_methods         = var.ordered_cached_methods_1
        compress               = var.ordered_compress_1
        default_ttl            = var.ordered_default_ttl_1
        max_ttl                = var.ordered_max_ttl_1

        forwarded_values {
          query_string = false
          headers      = ["Origin"]

          cookies {
            forward = "none"
          }
        }

        min_ttl                = var.ordered_min_ttl_1
        path_pattern           = "/static*"
        smooth_streaming       = var.ordered_smooth_streaming_1
        target_origin_id       = "my-vik-test-public-bucket.s3.eu-central-1.amazonaws.com"
        viewer_protocol_policy = var.ordered_viewer_protocol_policy_1
    }
    ordered_cache_behavior {
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
        path_pattern           = "/index.html"
        smooth_streaming       = var.ordered_smooth_streaming_2
        target_origin_id       = "my-vik-test-public-bucket.s3.eu-central-1.amazonaws.com"
        viewer_protocol_policy = var.ordered_viewer_protocol_policy_2
    }

    origin {
        connection_attempts = var.connection_attempts_1
        connection_timeout  = var.connection_timeout_1
        domain_name         = "k8s-vonpolldev-8288e5a5e3-873653782.eu-central-1.elb.amazonaws.com"
        origin_id           = "k8s-vonpolldev-8288e5a5e3-873653782.eu-central-1.elb.amazonaws.com"

        custom_origin_config {
            http_port                = var.http_port
            https_port               = var.https_port
            origin_keepalive_timeout = var.origin_keepalive_timeout
            origin_protocol_policy   = var.origin_protocol_policy
            origin_read_timeout      = var.origin_read_timeout
            origin_ssl_protocols     = var.origin_ssl_protocols
        }
    }
    origin {
        connection_attempts = var.connection_attempts_2
        connection_timeout  = var.connection_timeout_2
        domain_name         = "my-vik-test-public-bucket.s3.eu-central-1.amazonaws.com"
        origin_id           = "my-vik-test-public-bucket.s3.eu-central-1.amazonaws.com"
    }

    restrictions {
        geo_restriction {
            restriction_type = var.restriction_type
        }
    }

    viewer_certificate {
        cloudfront_default_certificate = var.cloudfront_default_certificate
        minimum_protocol_version       = var.minimum_protocol_version
    }
}
