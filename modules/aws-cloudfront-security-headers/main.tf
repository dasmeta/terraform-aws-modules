locals {
  default_custom_headers = {
    server                    = { key = "Server", value = "CloudFront" }
    strict-transport-security = { key = "Strict-Transport-Security", value = "max-age=63072000; includeSubdomains; preload" }
    content-security-policy   = { key = "Content-Security-Policy", value = "default-src 'self' 'unsafe-inline' 'unsafe-eval' https: http: data: wss: blob:" }
    x-content-type-options    = { key = "X-Content-Type-Options", value = "nosniff" }
    x-frame-options           = { key = "X-Frame-Options", value = "SAMEORIGIN" }
    x-xss-protection          = { key = "X-XSS-Protection", value = "1; mode=block" }
    referrer-policy           = { key = "Referrer-Policy", value = "same-origin" }
    permissions-policy        = { key = "Permissions-Policy", value = "accelerometer=(self), ambient-light-sensor=(self), autoplay=(self), battery=(self), camera=(self), cross-origin-isolated=(self), display-capture=(self), document-domain=(self), encrypted-media=(self), execution-while-not-rendered=(self), execution-while-out-of-viewport=(self), fullscreen=(self), geolocation=(self), gyroscope=(self), magnetometer=(self), microphone=(self), midi=(self), navigation-override=(self), payment=(self), picture-in-picture=(self), publickey-credentials-get=(self), screen-wake-lock=(self), sync-xhr=(self), usb=(self), web-share=(self), xr-spatial-tracking=(self)" }
  }

  custom_headers = merge(local.default_custom_headers, var.override_custom_headers)
}
data "aws_partition" "current" {}

resource "aws_iam_role" "execution_role" {
  name               = "${var.name}-execution-role"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": [
            "edgelambda.amazonaws.com",
            "lambda.amazonaws.com"
          ]
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
  tags               = var.tags
}

data "aws_iam_policy_document" "execution_role" {
  statement {
    sid = "AllowCloudWatchLogs"
    actions = [
      "logs:CreateLogGroup",
      "logs:Cre
      ateLogStream",
      "logs:PutLogEvents"
    ]
    effect = "Allow"
    resources = [
      format(
        "arn:%s:logs:*::log-group:/aws/lambda/*:*:*",
        data.aws_partition.current.partition
      )
    ]
  }
}

resource "aws_iam_policy" "execution_role" {
  name   = "${var.name}-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.execution_role.json
}

resource "aws_iam_role_policy_attachment" "execution_role" {
  role       = aws_iam_role.execution_role.name
  policy_arn = aws_iam_policy.execution_role.arn
}

data "archive_file" "this" {
  type        = "zip"
  output_path = "${path.module}/deploy.zip"
  source {
    content = templatefile(
      "${path.module}/src/index.js.tpl",
      {
        custom_headers = local.custom_headers
      }
    )
    filename = "index.js"
  }
}

resource "aws_lambda_function" "this" {
  function_name                  = var.name
  description                    = var.description
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "index.handler"
  runtime                        = var.runtime
  role                           = aws_iam_role.execution_role.arn
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  publish                        = true
  tags                           = var.tags
  reserved_concurrent_executions = 100
  tracing_config {
    mode = "Active"
  }

  depends_on = [
    data.archive_file.this
  ]
}
