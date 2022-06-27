{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "apigateway:GET",
      "Resource": [
        "arn:aws:apigateway:*::/account",
         "arn:aws:apigateway:*::/apis",
        "arn:aws:apigateway:*::/restapis",
        "arn:aws:apigateway:*::/restapis/${restapi_name}",
        "arn:aws:apigateway:*::/restapis/${restapi_name}/*"

      ]
    },
    {
      "Sid": "VisualEditor4",
      "Effect": "Allow",
      "Action": "apigateway:*",
      "Resource": [
        "arn:aws:apigateway:*::/apikeys/*",
        "arn:aws:apigateway:*::/apikeys",
        "arn:aws:apigateway:*::/usageplans",
        "arn:aws:apigateway:*::/usageplans/*"
      ]
    }
  ]
}
