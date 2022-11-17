module "infra-secret" {
  source = "dasmeta/modules/aws//modules/secret-reader"

  name = "test-project/dev/infra-secret"
}

locals {
  RABBITMQ_USER     = module.infra-secret.secrets["RABBITMQ_USER"]
  RABBITMQ_PASSWORD = module.infra-secret.secrets["RABBITMQ_PASSWORD"]
  JWT_KEY           = module.infra-secret.secrets["JWT_KEY"]
  JWT_ALGORITHM     = module.infra-secret.secrets["JWT_ALGORITHM"]
}

module "service-secret" {
  source  = "dasmeta/modules/aws//modules/secret"
  version = "1.2.0"

  name = "test-project/dev/app-secret"
  value = {
    "RABBITMQ_USER" : local.RABBITMQ_USER
    "RABBITMQ_PASSWORD" : local.RABBITMQ_PASSWORD
    "JWT_KEY" : local.JWT_KEY
    "JWT_ALGORITHM" : local.JWT_ALGORITHM
  }
}
