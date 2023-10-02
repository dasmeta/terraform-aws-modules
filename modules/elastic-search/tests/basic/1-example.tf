module "this" {
  source = "../../"


  domain_name                               = "dev"
  vpc_options_subnet_ids                    = ["subnet-id1", "subnet-id2"]
  vpc_options_security_group_whitelist_cidr = ["10.16.0.0/16"]
  ebs_options_volume_size                   = 10

  encrypt_at_rest_enabled                                  = true
  advanced_security_options_enabled                        = true
  advanced_security_options_internal_user_database_enabled = true
  advanced_security_options_master_user_username           = "admin"
  advanced_security_options_create_random_master_password  = true
  // Or you can use advanced_security_options_master_user_password variable
}
