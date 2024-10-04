module "this" {
  count = var.create_response_headers_policy.enabled ? 1 : 0

  source           = "./modules/response_headers/"
  name             = var.create_response_headers_policy.name
  security_headers = var.create_response_headers_policy.security_headers
}
