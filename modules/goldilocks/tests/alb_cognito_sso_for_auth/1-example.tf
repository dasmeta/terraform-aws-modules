locals {
  cognito = {
    test = {
      auth = {
        userPoolARN      = module.goldilocks-cognito[0].arn
        userPoolClientID = module.goldilocks-cognito[0].clients_id[0]
        userPoolDomain   = "goldilocks.auth.eu-central-1.amazoncognito.com"
      }
      alias = {
        name    = data.aws_lb.alb.dns_name
        zone_id = data.aws_lb.alb.zone_id
      }
    }
  }
  zone_name = "test.dasmeta.com"
}

data "aws_route53_zone" "zone" {
  name = local.zone_name
}

data "aws_lb" "alb" {
  name = "alb-name"
}

module "ssl-certificate-auth" {
  source = "dasmeta/modules/aws//modules/ssl-certificate"
  domain = "goldilocks.test.dasmeta.com"
  zone   = local.zone_name
}

module "goldilocks" {
  source = "../../"

  namespaces           = ["default"]
  zone_name            = local.zone_name
  hostname             = "goldilocks.test.dasmeta.com"
  alb_certificate_arn  = module.ssl-certificate-auth.arn
  create_metric_server = false
  auth                 = local.cognito["test"].auth
  alb_name             = "goldilocks-dashboard"
}

module "goldilocks-cognito" {
  source                               = "dasmeta/modules/aws//modules/cognito-user-pool/"
  count                                = 1
  version                              = "0.26.2"
  name                                 = "goldilocks-dashboard"
  clients                              = ["main"]
  auto_verified_attributes             = ["email"]
  generate_secret                      = true
  supported_identity_providers         = ["SSO"]
  domain                               = "goldilocks"
  allowed_oauth_flows_user_pool_client = true
  create_route53_record                = false
  zone_id                              = data.aws_route53_zone.zone.zone_id
  callback_urls                        = ["https://goldilocks.test.dasmeta.com/oauth2/idpresponse"]
  allowed_oauth_scopes                 = ["email", "openid", "phone"]
  allowed_oauth_flows                  = ["code"]

  schema = [{
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true
    string_attribute_constraints = {
      max_length = "2048"
      min_length = "0"
    }
  }]
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "goldilocks"
  type    = "A"

  alias {
    name                   = local.cognito["test"].alias.name
    zone_id                = local.cognito["test"].alias.zone_id
    evaluate_target_health = true
  }
}
