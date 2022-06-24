{
  openapi = "3.0.1"
  info = {
  title   = var.info_title #Need to export #api_gw
  version = var.info_version #Need to export #1.0
}
paths = {
  "/path1" = {
  get = {
  x-amazon-apigateway-integration = {
  httpMethod           = "GET"
  payloadFormatVersion = "1.0"
  type                 = "HTTP_PROXY"
  uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
}
}
}
}
}