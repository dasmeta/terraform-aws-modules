locals {
  default_origin_index = length(var.origins) - 1 # the default origin behavior is last one from origins listing
}

resource "aws_cloudfront_distribution" "this" {
  count = var.create_distribution ? 1 : 0

  aliases             = var.aliases
  comment             = var.comment
  default_root_object = var.default_root_object
  enabled             = var.enabled
  http_version        = var.http_version
  is_ipv6_enabled     = var.is_ipv6_enabled
  price_class         = var.price_class
  retain_on_delete    = var.retain_on_delete
  wait_for_deployment = var.wait_for_deployment
  web_acl_id          = var.web_acl_id
  tags                = var.tags

  dynamic "logging_config" {
    for_each = length(keys(var.logging_config)) == 0 ? [] : [var.logging_config]

    content {
      bucket          = logging_config.value["bucket"]
      prefix          = lookup(logging_config.value, "prefix", null)
      include_cookies = lookup(logging_config.value, "include_cookies", null)
    }
  }

  dynamic "origin" {
    for_each = var.origins

    content {
      domain_name         = try(origin.value.type, null) == "bucket" ? data.aws_s3_bucket.origins[origin.value.id].bucket_regional_domain_name : origin.value.domain_name
      origin_id           = origin.value.id
      origin_path         = lookup(origin.value, "origin_path", "")
      connection_attempts = lookup(origin.value, "connection_attempts", null)
      connection_timeout  = lookup(origin.value, "connection_timeout", null)

      dynamic "s3_origin_config" {
        for_each = { for key, origin_access_identity in aws_cloudfront_origin_access_identity.this : key => origin_access_identity if key == origin.value.id }

        content {
          origin_access_identity = s3_origin_config.value.cloudfront_access_identity_path
        }
      }

      dynamic "custom_origin_config" { # custom_origin_config block required for non bucket type origins and should not be set for bucket origins
        for_each = try(origin.value.type, null) == "bucket" ? [] : [lookup(origin.value, "custom_origin_config", {})]

        content {
          http_port                = try(custom_origin_config.value.http_port, 80)
          https_port               = try(custom_origin_config.value.https_port, 443)
          origin_protocol_policy   = try(custom_origin_config.value.origin_protocol_policy, "match-viewer")
          origin_ssl_protocols     = try(custom_origin_config.value.origin_ssl_protocols, ["TLSv1.2"])
          origin_keepalive_timeout = try(custom_origin_config.value.origin_keepalive_timeout, null)
          origin_read_timeout      = try(custom_origin_config.value.origin_read_timeout, null)
        }
      }

      dynamic "custom_header" {
        for_each = lookup(origin.value, "custom_header", [])

        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      dynamic "origin_shield" {
        for_each = length(keys(lookup(origin.value, "origin_shield", {}))) == 0 ? [] : [lookup(origin.value, "origin_shield", {})]

        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = origin_shield.value.origin_shield_region
        }
      }
    }
  }

  dynamic "origin_group" {
    for_each = var.origin_group

    content {
      origin_id = lookup(origin_group.value, "origin_id", origin_group.key)

      failover_criteria {
        status_codes = origin_group.value["failover_status_codes"]
      }

      member {
        origin_id = origin_group.value["primary_member_origin_id"]
      }

      member {
        origin_id = origin_group.value["secondary_member_origin_id"]
      }
    }
  }

  default_cache_behavior {
    target_origin_id       = var.origins[local.default_origin_index].id
    viewer_protocol_policy = try(var.origins[local.default_origin_index].behavior.viewer_protocol_policy, "redirect-to-https")

    allowed_methods           = try(var.origins[local.default_origin_index].behavior.allowed_methods, ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"])
    cached_methods            = try(var.origins[local.default_origin_index].behavior.cached_methods, ["GET", "HEAD"])
    compress                  = try(var.origins[local.default_origin_index].behavior.compress, null)
    field_level_encryption_id = try(var.origins[local.default_origin_index].behavior.field_level_encryption_id, null)
    smooth_streaming          = try(var.origins[local.default_origin_index].behavior.smooth_streaming, null)
    trusted_signers           = try(var.origins[local.default_origin_index].behavior.trusted_signers, null)
    trusted_key_groups        = try(var.origins[local.default_origin_index].behavior.trusted_key_groups, null)

    cache_policy_id            = try(var.origins[local.default_origin_index].behavior.cache_policy_id, null)
    origin_request_policy_id   = try(var.origins[local.default_origin_index].behavior.origin_request_policy_id, null)
    response_headers_policy_id = try(var.origins[local.default_origin_index].behavior.response_headers_policy_id, null)
    realtime_log_config_arn    = try(var.origins[local.default_origin_index].behavior.realtime_log_config_arn, null)

    min_ttl     = try(var.origins[local.default_origin_index].behavior.min_ttl, null)
    default_ttl = try(var.origins[local.default_origin_index].behavior.default_ttl, null)
    max_ttl     = try(var.origins[local.default_origin_index].behavior.max_ttl, null)

    dynamic "forwarded_values" {
      for_each = try(var.origins[local.default_origin_index].behavior.use_forwarded_values, true) ? [true] : []

      content {
        query_string            = try(var.origins[local.default_origin_index].behavior.query_string, true)
        query_string_cache_keys = try(var.origins[local.default_origin_index].behavior.query_string_cache_keys, [])
        headers                 = try(var.origins[local.default_origin_index].behavior.headers, [])

        cookies {
          forward           = try(var.origins[local.default_origin_index].behavior.cookies_forward, "all")
          whitelisted_names = try(var.origins[local.default_origin_index].behavior.cookies_whitelisted_names, null)
        }
      }
    }

    dynamic "lambda_function_association" {
      for_each = var.create_hsts ? [true] : try(var.origins[local.default_origin_index].behavior.lambda_function_association, [])
      iterator = l

      content {
        event_type   = var.create_hsts ? "viewer-response" : l.key
        lambda_arn   = var.create_hsts ? module.aws-cloudfront-security-headers[0].lambda_arn : l.value.lambda_arn
        include_body = var.create_hsts ? false : lookup(l.value, "include_body", null)
      }
    }

    dynamic "function_association" {
      for_each = try(var.origins[local.default_origin_index].behavior.function_association, [])
      iterator = f

      content {
        event_type   = f.key
        function_arn = f.value.function_arn
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = { for key, origin in var.origins : key => origin if key != local.default_origin_index }
    iterator = i

    content {
      path_pattern           = i.value.behavior["path_pattern"] # non default origins should have behavior.path_pattern
      target_origin_id       = i.value.id
      viewer_protocol_policy = try(i.value.behavior.viewer_protocol_policy, "redirect-to-https")

      allowed_methods           = try(i.value.behavior.allowed_methods, ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"])
      cached_methods            = try(i.value.behavior.cached_methods, ["GET", "HEAD"])
      compress                  = try(i.value.behavior.compress, null)
      field_level_encryption_id = try(i.value.behavior.field_level_encryption_id, null)
      smooth_streaming          = try(i.value.behavior.smooth_streaming, null)
      trusted_signers           = try(i.value.behavior.trusted_signers, null)
      trusted_key_groups        = try(i.value.behavior.trusted_key_groups, null)

      cache_policy_id            = try(i.value.behavior.cache_policy_id, null)
      origin_request_policy_id   = try(i.value.behavior.origin_request_policy_id, null)
      response_headers_policy_id = try(i.value.behavior.response_headers_policy_id, null)
      realtime_log_config_arn    = try(i.value.behavior.realtime_log_config_arn, null)

      min_ttl     = try(i.value.behavior.min_ttl, null)
      default_ttl = try(i.value.behavior.default_ttl, null)
      max_ttl     = try(i.value.behavior.max_ttl, null)

      dynamic "forwarded_values" {
        for_each = try(i.value.behavior.use_forwarded_values, true) ? [true] : []

        content {
          query_string            = try(i.value.behavior.query_string, true)
          query_string_cache_keys = try(i.value.behavior.query_string_cache_keys, [])
          headers                 = try(i.value.behavior.headers, [])

          cookies {
            forward           = try(i.value.behavior.cookies_forward, "all")
            whitelisted_names = try(i.value.behavior.cookies_whitelisted_names, null)
          }
        }
      }

      dynamic "lambda_function_association" {
        for_each = try(i.value.behavior.lambda_function_association, [])
        iterator = l

        content {
          event_type   = l.key
          lambda_arn   = l.value.lambda_arn
          include_body = lookup(l.value, "include_body", null)
        }
      }

      dynamic "function_association" {
        for_each = try(i.value.behavior.function_association, [])
        iterator = f

        content {
          event_type   = f.key
          function_arn = f.value.function_arn
        }
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.create_certificate ? module.ssl-certificate-auth[0].arn : lookup(var.viewer_certificate, "acm_certificate_arn", null)
    cloudfront_default_certificate = lookup(var.viewer_certificate, "cloudfront_default_certificate", null)
    iam_certificate_id             = lookup(var.viewer_certificate, "iam_certificate_id", null)

    minimum_protocol_version = lookup(var.viewer_certificate, "minimum_protocol_version", "TLSv1.2_2021")
    ssl_support_method       = var.create_certificate ? "sni-only" : lookup(var.viewer_certificate, "ssl_support_method", null)
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_response

    content {
      error_code = custom_error_response.value["error_code"]

      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
    }
  }

  restrictions {
    dynamic "geo_restriction" {
      for_each = [var.geo_restriction]

      content {
        restriction_type = lookup(geo_restriction.value, "restriction_type", "none")
        locations        = lookup(geo_restriction.value, "locations", [])
      }
    }
  }

  depends_on = [module.aws-cloudfront-security-headers, module.ssl-certificate-auth]

  provider = aws.virginia
}

resource "aws_cloudfront_monitoring_subscription" "this" {
  count = var.create_distribution && var.create_monitoring_subscription ? 1 : 0

  distribution_id = aws_cloudfront_distribution.this[local.default_origin_index].id

  monitoring_subscription {
    realtime_metrics_subscription_config {
      realtime_metrics_subscription_status = var.realtime_metrics_subscription_status
    }
  }

  provider = aws.virginia
}
