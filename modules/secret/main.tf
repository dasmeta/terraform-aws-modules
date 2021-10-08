module "mongodb-atlas" {
  source = "dasmeta/modules/aws//modules/mongodb-atlas"

  org_id = var.mongodb_atlas_org_id
  public_key = var.mongodb_atlas_public_key
  private_key = var.mongodb_atlas_private_key
  project_name = var.project_name
  users = var.users
  ip_addresses = var.ip_addresses
  aws_account_id = var.aws_account_id
}

module "mongo-cr" {
  source = "../aws-secret"
  
  for_each = module.mongodb-atlas.users

  name = each.key
  secret_value = each.value
}
