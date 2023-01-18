module "this" {
  source = "../../"

  name              = "audit-logs"
  insight_selectors = ["ApiCallRateInsight", "ApiErrorRateInsight"]
  event_selector = [
    {
      exclude_management_event_sources = [],
      include_management_events        = true
      read_write_type                  = "All"

      data_resource = [
        {
          type = "AWS::S3::Object",
          values = [
            "arn:aws:s3",
          ]
        },
        {
          type = "AWS::Lambda::Function",
          values = [
            "arn:aws:lambda",
          ]
        },
      ]
    }
  ]
}
