# Define IAM role for lambda execution: needed before creating lambda functions
resource "aws_iam_role" "iam_for_lambda_health_check" {
  name = "${replace(var.domen_name, ".", "-")}-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
