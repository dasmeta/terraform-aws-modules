resource "aws_api_gateway_rest_api" "api_gw" {
  #file("${path.module}/sample.json")
  body = jsonencode(file("${path.module}/sample.json"))

  name = var.name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "aws-api-depl" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_gw.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "aws-api-stage" {
  deployment_id = aws_api_gateway_deployment.aws-api-depl.id
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  stage_name    = var.stage_name
}