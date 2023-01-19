module "cmdb" {
  source = "./modules/cmdb-integration"
  count  = var.cmdb_integration.enabled ? 1 : 0

  name             = var.name
  bucket_name      = local.s3_bucket_name
  cmdb_integration = var.cmdb_integration
}
