module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.7.1"

  function_name = var.name
  handler       = "lambda.handler"
  runtime       = "nodejs14.x"
  publish       = true
  source_path   = "${path.module}/src/"

  role_name             = var.name
  environment_variables = var.cmdb_integration_config.environment_variables
}
