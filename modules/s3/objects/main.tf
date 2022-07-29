// push folder files into bucket
resource "aws_s3_object" "bucket_files" {
  for_each = fileset(var.path, var.pattern)

  bucket       = var.bucket
  key          = each.value
  source       = "${var.path}${each.value}"
  acl          = var.acl
  content_type = lookup(local.extension_to_content_type, regex("[^.]+$", each.value), null)
  etag         = filemd5("${var.path}${each.value}") # have some trigger to update remote file if local file changed
}
