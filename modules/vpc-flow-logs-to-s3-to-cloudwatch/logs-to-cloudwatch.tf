data "aws_s3_bucket" "selected" {
  count  = var.create_bucket ? 0 : 1
  bucket = var.bucket_name
}

resource "aws_cloudwatch_log_group" "cloudwatch_log" {
  count = var.create_lambda_s3_to_cloudwatch ? 1 : 0

  name              = "vpc-log-${var.bucket_name}"
  retention_in_days = 365
  kms_key_id        = var.kms_key_id
}

module "s3_logs_to_cloudwatch" {
  count = var.create_lambda_s3_to_cloudwatch ? 1 : 0

  source         = "./vpc-logs-to-cloudwatch"
  bucket_name    = var.bucket_name
  log_group_name = aws_cloudwatch_log_group.cloudwatch_log[0].name
}

resource "aws_lambda_permission" "bucket" {
  count = var.create_lambda_s3_to_cloudwatch ? 1 : 0

  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.s3_logs_to_cloudwatch[0].function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.create_bucket ? aws_s3_bucket.bucket[0].arn : data.aws_s3_bucket.selected[0]

  depends_on = [
    aws_s3_bucket.bucket
  ]
}

resource "aws_s3_bucket_notification" "logs" {
  count = var.create_lambda_s3_to_cloudwatch ? 1 : 0

  bucket = var.bucket_name
  lambda_function {
    lambda_function_arn = module.s3_logs_to_cloudwatch[0].function_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [
    aws_lambda_permission.bucket
  ]
}
