data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

module "lambda" {
  source  = "raymondbutcher/lambda-builder/aws"
  version = "1.1.0"

  function_name = coalesce(var.function_name, "${substr(var.bucket_name, 0, 45)}-to-cloudwatch-logs")
  handler       = "lambda.handler"
  runtime       = "python3.7"
  memory_size   = var.memory_size
  timeout       = var.timeout

  build_mode = "FILENAME"
  source_dir = "${path.module}/src"
  filename   = "${path.module}/package.zip"

  role_cloudwatch_logs       = true
  role_custom_policies       = [data.aws_iam_policy_document.lambda.json]
  role_custom_policies_count = 1

  environment = {
    variables = {
      LOG_GROUP_NAME = var.log_group_name
    }
  }
}

data "aws_iam_policy_document" "lambda" {
  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
  }
  statement {
    actions   = ["logs:CreateLogStream", "logs:DeleteLogStream", "logs:PutLogEvents"]
    effect    = "Allow"
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.log_group_name}:log-stream:*"]
  }
}

resource "aws_cloudwatch_metric_alarm" "errors" {
  count = var.create_alarm ? 1 : 0

  alarm_name        = "${module.lambda.function_name}-errors"
  alarm_description = "${module.lambda.function_name} invocation errors"

  namespace   = "AWS/Lambda"
  metric_name = "Errors"

  dimensions = {
    FunctionName = module.lambda.function_name
  }

  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 0
  period              = 60 * 60
  evaluation_periods  = 1

  # alarm_actions = var.alarm_actions
  # ok_actions    = var.ok_actions
}
