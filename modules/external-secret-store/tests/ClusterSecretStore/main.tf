module "test" {
  source = "../../"

  name      = "test"
  namespace = "test"
  kind      = "ClusterSecretStore"

}
