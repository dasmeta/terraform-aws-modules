module "cmdb" {
  source = "./modules/cmdb-integration"
  count  = var.cmdb_integration.enabled ? 1 : 0

  name        = var.name
  bucket_name = local.s3_bucket_name
  configs     = var.cmdb_integration.configs
}
