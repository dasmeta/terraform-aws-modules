data "aws_region" "current" {}

module "api_iam_user" {
  source = "dasmeta/modules/aws//modules/aws-iam-user"

  create_user = var.create_iam_user
  username    = var.iam_username
  console     = false
  policy = templatefile("${path.module}/src/iam-policy.json.tpl", {
    restapi_name = aws_api_gateway_rest_api.api-gateway.id
    region       = data.aws_region.current.name
  })
  pgp_key = var.pgp_key
}
