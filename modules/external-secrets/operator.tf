module "release" {
  source  = "terraform-module/release/helm"
  version = "2.6.9"

  namespace  = var.namespace
  repository = "https://charts.external-secrets.io"

  app = {
    name    = "external-secrets"
    version = "0.3.5"
    chart   = "external-secrets"
    # force_update  = true
    # wait          = true
    recreate_pods = false
    deploy        = 1
  }

  values = []

  set = [
    # {
    #   name  = "config.MONGODB_HOST"
    #   value = var.mongodb-host
    # },
  ]

  set_sensitive = [
    # {
    #   path  = "config.AWS_ACCESS_KEY_ID"
    #   value = var.aws-access-key-id
    # },
  ]
}
