module "goldilocks" {
  source                   = "../../"
  namespaces               = ["default"]
  create_metric_server     = false
  create_dashboard_ingress = false
}
