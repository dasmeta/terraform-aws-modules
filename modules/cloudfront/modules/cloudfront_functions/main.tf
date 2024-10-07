resource "aws_cloudfront_function" "this" {
  name    = var.name
  runtime = var.runtime
  comment = var.comment
  publish = var.publish
  code    = var.code
}
