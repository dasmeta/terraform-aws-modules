module "basic" {
  source = "../.."

  root_password  = md5(timestamp())
  replicaset_key = md5(timestamp())
}
