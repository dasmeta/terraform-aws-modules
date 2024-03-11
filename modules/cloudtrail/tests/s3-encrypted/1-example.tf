module "cloudtrail_new" {
  source = "../../"

  name                   = "infra-cloudtrail"
  kms_key_arn            = ""
  enable_cloudwatch_logs = true

  event_selector = [{
    read_write_type           = "All"
    include_management_events = true

    data_resource = [{
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }]
  }]
}
