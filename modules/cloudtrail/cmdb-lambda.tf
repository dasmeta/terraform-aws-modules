module "cmdb" {
  source = "./cmdb-integration"
  count  = var.enable_cmdb_integration ? 1 : 0

  name                    = var.name
  bucket_name             = local.s3_bucket_name
  cmdb_integration_config = var.cmdb_integration_config
}
