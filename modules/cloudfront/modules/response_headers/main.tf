# CloudFront custom response headers policy
resource "aws_cloudfront_response_headers_policy" "this" {
  name = var.name

  custom_headers_config {
    dynamic "items" {
      for_each = var.custom_headers
      content {
        header   = items.value.header
        override = items.value.override
        value    = items.value.value
      }
    }
  }

  dynamic "security_headers_config" {
    for_each = var.security_headers.frame_options != null ? [1] : []
    content {
      frame_options {
        override     = true
        frame_option = var.security_headers.frame_options
      }
    }
  }
}
