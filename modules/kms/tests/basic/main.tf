module "kms_for_cloudwatch" {
  source = "../../"

  kms_key_description = "Encryption key for example log group"
  kms_alias_name      = "example-log-group-key"
}
