module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.8.0"

  function_name = var.name
  handler       = "lambda.handler"
  runtime       = "nodejs20.x"
  publish       = true
  source_path   = "${path.module}/src/"

  role_name = var.name
}
