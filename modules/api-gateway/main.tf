resource "aws_api_gateway_rest_api" "api-gateway" {

  name = var.name

  body = templatefile(var.open_api_path != "" ? var.open_api_path : "${path.module}/src/sample.json.tpl" ,  {
    path1 = "/"
    method1= "get"
    response_code="200"
  })



  endpoint_configuration {
    types = [var.endpoint_config_type]
  }
}

#data "template_file" "open_api" {
#  template = file("${path.module}/templates/sample.tftpl")
#}

resource "aws_api_gateway_deployment" "aws-api-depl" {
  rest_api_id = var.rest_api_id != "" ? var.rest_api_id : aws_api_gateway_rest_api.api-gateway.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api-gateway.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "aws-api-stage" {
  deployment_id = aws_api_gateway_deployment.aws-api-depl.id
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  stage_name    = var.stage_name
}



