resource "aws_iam_role" "unauthenticated" {
  name = var.unauthenticated_role

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.identity-pool.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "unauthenticated"
        }
      }
    }
  ]
}
EOF

    max_session_duration  = 3600
    path                  = "/"

    inline_policy {
        name   = var.unauth_inline_policy
        policy = jsonencode(
            {
                Statement = [
                    {
                        Action   = [
                            "mobileanalytics:PutEvents",
                            "cognito-sync:*",
                        ]
                        Effect   = "Allow"
                        Resource = [
                            "*",
                        ]
                    },
                ]
                Version   = "2012-10-17"
            }
        )
    }
}
