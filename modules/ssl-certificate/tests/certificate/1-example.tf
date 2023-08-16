module "this" {
  source = "../.."

  validate = false
  domain   = "*.dasmeta.com"
}

output "records" {
  value = module.this.cname_records
}
