module "cloudtrail" {
  source = "../../"
  name   = "cloudtrail"

  event_selector = [{
    read_write_type           = "All"
    include_management_events = true

    data_resource = [{
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }]
  }]
}
