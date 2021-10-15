provider "aws" {
    region = "us-east-1"
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
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
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
      "logs:CreateLogStream",
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
    content = templatefile("${path.module}/src/index.js.tpl",{})
    filename = "index.js"
  }
}

resource "aws_lambda_function" "this" {
  function_name    = var.name
  description      = var.description
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256
  handler          = "index.handler"
  runtime          = var.runtime
  role             = aws_iam_role.execution_role.arn
  timeout          = var.timeout
  memory_size      = var.memory_size
  publish          = true
  tags             = var.tags
  depends_on = [
    data.archive_file.this
  ]
}
