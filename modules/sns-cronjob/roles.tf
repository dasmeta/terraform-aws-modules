resource "aws_iam_role" "success_logger" {
  name = "${var.name}-cron-success-logger"

  assume_role_policy = <<EOL
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Principal": {
              "Service": "sns.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
      }
  ]
}
EOL

  inline_policy {
    name   = "${var.name}-cron-success-logger"
    policy = <<EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:PutMetricFilter",
                "logs:PutRetentionPolicy"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOL
  }
}

resource "aws_iam_role" "failure_logger" {
  name = "${var.name}-cron-failure-logger"

  assume_role_policy = <<EOL
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Principal": {
              "Service": "sns.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
      }
  ]
}
EOL

  inline_policy {
    name   = "${var.name}-cron-failure-logger"
    policy = <<EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:PutMetricFilter",
                "logs:PutRetentionPolicy"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOL
  }
}
