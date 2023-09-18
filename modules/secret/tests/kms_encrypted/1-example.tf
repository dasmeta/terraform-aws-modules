module "this" {
  source = "../../"

  name = "test-secret"
  value = {
    my_super_secret_key = "my_super_secret_value"
  }
  recovery_window_in_days = 0 # to destroy the secret immediately and not wait some days(default is 30) for recovery
  kms_key_id              = "arn:aws:kms:us-east-1:000000000000:key/0000000000000"
}
