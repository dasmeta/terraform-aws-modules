# as stated in docs: 
## Provides a settings of an API Gateway Account. Settings is applied region-wide per provider block.
## As there is no API method for deleting account settings or resetting it to defaults, destroying this resource will keep your account settings intact
resource "aws_api_gateway_account" "account_settings" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_global"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  lifecycle {
    prevent_destroy = true # this resource is account wide usable, so we prevent destroying it to to have further issue in future, you will need to remove resource state from your state to have this
  }
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "default"
  role = aws_iam_role.cloudwatch.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF

  lifecycle {
    prevent_destroy = true # this resource is account wide usable, so we prevent destroying it to to have further issue in future, you will need to remove resource state from your state to have this
  }
}
