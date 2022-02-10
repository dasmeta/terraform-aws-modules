Module use examples.

# Example 1
```
module "cloudtrail" {
  source         = "dasmeta/modules/aws//modules/cloudtrail/"
  name           = "cloudtrail"
}
```

# Example 2
```
module "cloudtrail" {
  source         = "dasmeta/modules/aws//modules/cloudtrail/"
  name           = "cloudtrail"
  sns_topic_name = ""
  event_selector = [{
    read_write_type           = "All"
    include_management_events = true

    data_resource = [{
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }]
  }]
  cloud_watch_logs_group_arn = ""
  cloud_watch_logs_role_arn  = ""
  enable_logging             = true
}
```