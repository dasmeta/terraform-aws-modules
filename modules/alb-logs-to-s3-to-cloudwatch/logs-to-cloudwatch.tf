data "aws_s3_bucket" "selected" {
  count  = var.create_alb_log_bucket ? 0 : 1
  bucket = var.alb_log_bucket_name
}

resource "aws_cloudwatch_log_group" "log" {
  count             = var.create_lambda ? 1 : 0
  name              = "alb-${var.alb_log_bucket_name}"
  retention_in_days = 365
}

module "alb_logs_to_cloudwatch" {
  count  = var.create_lambda ? 1 : 0
  source = "./alb-to-s3-to-cloudwatch-lambda"

  bucket_name    = var.alb_log_bucket_name
  log_group_name = aws_cloudwatch_log_group.log[0].name

  create_alarm = false
}

resource "aws_lambda_permission" "bucket" {
  count = var.create_lambda ? 1 : 0

  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.alb_logs_to_cloudwatch[0].function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.create_alb_log_bucket ? module.s3_log_bucket[0].s3_bucket_arn : data.aws_s3_bucket.selected[0].arn
}

resource "aws_s3_bucket_notification" "logs" {
  count = var.create_lambda ? 1 : 0

  bucket = var.alb_log_bucket_name

  depends_on = [
    aws_lambda_permission.bucket
  ]

  lambda_function {
    lambda_function_arn = module.alb_logs_to_cloudwatch[0].function_arn
    events              = ["s3:ObjectCreated:*"]
  }
}
