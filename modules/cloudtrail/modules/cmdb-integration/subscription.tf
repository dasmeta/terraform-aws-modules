resource "aws_s3_bucket_notification" "incoming" {
  bucket = var.bucket_name

  lambda_function {
    lambda_function_arn = module.lambda.lambda_function_arn
    events              = ["s3:ObjectCreated:Put"]
  }

  depends_on = [aws_lambda_permission.s3_permission_to_trigger_lambda]
}

resource "aws_lambda_permission" "s3_permission_to_trigger_lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_name}"
}

data "aws_iam_policy_document" "destination_on_success" {
  statement {
    actions = [
      "sns:Publish",
      "sqs:SendMessage",
      "lambda:InvokeFunction",
      "events:PutEvents"
    ]
    resources = [
      module.topic.arn
    ]
  }
}

resource "aws_iam_role_policy" "destination_on_success" {
  name   = "lambda-destination-sns"
  policy = data.aws_iam_policy_document.destination_on_success.json
  role   = var.name
}


resource "aws_lambda_function_event_invoke_config" "destination" {
  function_name = module.lambda.lambda_function_arn

  destination_config {
    on_failure {
      destination = module.topic.arn
    }

    on_success {
      destination = module.topic.arn
    }
  }

  depends_on = [
    aws_iam_role_policy.destination_on_success
  ]
}
