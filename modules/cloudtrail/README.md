Module use examples.

# Example 1 Logging All Management account

```
module "cloudtrail" {
  source         = "dasmeta/modules/aws//modules/cloudtrail/"
  name           = "audit-logs"
}
```

# Example 2 Logging All S3 Object Events By Using Basic Event Selectors

```
module "cloudtrail" {
  source = "dasmeta/modules/aws//modules/cloudtrail/"
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
```

# Example 3 Logging All Lambda Function Invocations By Using Basic Event Selectors

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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                          | Type        |
| ----------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudtrail.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail)           | resource    |
| [aws_s3_bucket.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                     | resource    |
| [aws_s3_bucket_policy.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)       | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name                                                                                                                     | Description                                                                                                                                                  | Type                                                                                                                                                                                         | Default | Required |
| ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | :------: |
| <a name="input_bucket_name"></a> [bucket_name](#input_bucket_name)                                                       | n/a                                                                                                                                                          | `string`                                                                                                                                                                                     | `null`  |    no    |
| <a name="input_cloud_watch_logs_group_arn"></a> [cloud_watch_logs_group_arn](#input_cloud_watch_logs_group_arn)          | Specifies a log group name using an Amazon Resource Name (ARN), that represents the log group to which CloudTrail logs will be delivered                     | `string`                                                                                                                                                                                     | `""`    |    no    |
| <a name="input_cloud_watch_logs_role_arn"></a> [cloud_watch_logs_role_arn](#input_cloud_watch_logs_role_arn)             | Specifies the role for the CloudWatch Logs endpoint to assume to write to a user’s log group                                                                 | `string`                                                                                                                                                                                     | `""`    |    no    |
| <a name="input_create_s3_bucket"></a> [create_s3_bucket](#input_create_s3_bucket)                                        | n/a                                                                                                                                                          | `bool`                                                                                                                                                                                       | `true`  |    no    |
| <a name="input_enable_log_file_validation"></a> [enable_log_file_validation](#input_enable_log_file_validation)          | Specifies whether log file integrity validation is enabled. Creates signed digest for validated contents of logs                                             | `bool`                                                                                                                                                                                       | `true`  |    no    |
| <a name="input_enable_logging"></a> [enable_logging](#input_enable_logging)                                              | Enable logging for the trail                                                                                                                                 | `bool`                                                                                                                                                                                       | `true`  |    no    |
| <a name="input_event_selector"></a> [event_selector](#input_event_selector)                                              | Specifies an event selector for enabling data event logging. See: https://www.terraform.io/docs/providers/aws/r/cloudtrail.html for details on this variable | <pre>list(object({<br> include_management_events = bool<br> read_write_type = string<br><br> data_resource = list(object({<br> type = string<br> values = list(string)<br> }))<br> }))</pre> | `[]`    |    no    |
| <a name="input_include_global_service_events"></a> [include_global_service_events](#input_include_global_service_events) | Specifies whether the trail is publishing events from global services such as IAM to the log files                                                           | `bool`                                                                                                                                                                                       | `true`  |    no    |
| <a name="input_is_multi_region_trail"></a> [is_multi_region_trail](#input_is_multi_region_trail)                         | Specifies whether the trail is created in the current region or in all regions                                                                               | `bool`                                                                                                                                                                                       | `true`  |    no    |
| <a name="input_is_organization_trail"></a> [is_organization_trail](#input_is_organization_trail)                         | The trail is an AWS Organizations trail                                                                                                                      | `bool`                                                                                                                                                                                       | `false` |    no    |
| <a name="input_name"></a> [name](#input_name)                                                                            | Name CloudTrail                                                                                                                                              | `string`                                                                                                                                                                                     | n/a     |   yes    |
| <a name="input_sns_topic_name"></a> [sns_topic_name](#input_sns_topic_name)                                              | Specifies the name of the Amazon SNS topic defined for notification of log file delivery                                                                     | `string`                                                                                                                                                                                     | `null`  |    no    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
