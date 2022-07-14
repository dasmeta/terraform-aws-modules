data "aws_region" "current" {}

module "api_iam_user" {
  source = "../aws-iam-user" # TODO: change to remote terraform repository
  # source  = "dasmeta/modules/aws//modules/aws-iam-user"
  # version = "0.35.2"

  create_user   = var.create_iam_user
  create_policy = true
  username      = "${var.name}-user"
  console       = false
  policy = templatefile("${path.module}/src/iam-policy.json.tpl", {
    api_gateway_id = aws_api_gateway_rest_api.this.id
    region         = data.aws_region.current.name
  })
  pgp_key = var.pgp_key
}
