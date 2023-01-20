module "this" {
  source = "../../"
  origins = [
    {
      target                   = "some-s3-bucket-name.s3.us-east-1.amazonaws.com"
      type                     = "bucket"
      origin_access_control_id = ""
      custom_origin_config     = []
    }
  ]
  use_default_cert         = true
  default_target_origin_id = "some-s3-bucket-name.s3.us-east-1.amazonaws.com"
  domain_names             = ["example.com"]

  logging_config = {
    enabled = true
    bucket  = "s3-logging-bucket"
  }
}
