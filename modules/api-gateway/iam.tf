resource "aws_iam_user" "api-gw-user" {
  name = var.iam_username
}

resource "aws_iam_access_key" "api-gw-ak" {
  user = aws_iam_user.api-gw-user.name
  pgp_key = var.pgp_key
}

resource "aws_iam_user_policy" "api-gw-policy" {
  name = var.policy_name
  user = aws_iam_user.api-gw-user.name

  policy = templatefile("${path.module}/src/iam-policy.json.tpl", {
    restapi_name = aws_api_gateway_rest_api.api-gateway.id
  })
}
