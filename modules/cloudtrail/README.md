Module use examples.

# Example 1: Logging All Management account

```
module "cloudtrail" {
  source         = "dasmeta/modules/aws//modules/cloudtrail/"
  name           = "audit-logs"
}
```

# Example 2: Logging All S3 Object Events By Using Basic Event Selectors

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

# Example 3: Logging All Lambda Function Invocations By Using Basic Event Selectors

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

# Example 4: Logging All Management Account and Sending to CloudWatch

```
module "cloudtrail" {
  source         = "dasmeta/modules/aws//modules/cloudtrail/"
  name           = "cloudtrail"

  enable_cloudwatch_logs = true
  enable_logging             = true
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.cloudtrail_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cloudtrail_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudtrail_roles_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | `null` | no |
| <a name="input_cloud_watch_logs_group_arn"></a> [cloud\_watch\_logs\_group\_arn](#input\_cloud\_watch\_logs\_group\_arn) | Specifies a log group name using an Amazon Resource Name (ARN), that represents the log group to which CloudTrail logs will be delivered | `string` | `""` | no |
| <a name="input_cloud_watch_logs_group_name"></a> [cloud\_watch\_logs\_group\_name](#input\_cloud\_watch\_logs\_group\_name) | Specifies a log group name that will be created to which CloudTrail logs will be delivered | `string` | `"aws-cloudtrail-logs"` | no |
| <a name="input_cloud_watch_logs_role_arn"></a> [cloud\_watch\_logs\_role\_arn](#input\_cloud\_watch\_logs\_role\_arn) | Specifies the role for the CloudWatch Logs endpoint to assume to write to a user’s log group | `string` | `""` | no |
| <a name="input_cloudtrail_assume_role_policy_document"></a> [cloudtrail\_assume\_role\_policy\_document](#input\_cloudtrail\_assume\_role\_policy\_document) | Assume role policy document. | `string` | `"{\n   \"Version\": \"2012-10-17\",\n   \"Statement\": [\n     {\n       \"Action\": \"sts:AssumeRole\",\n       \"Principal\": {\n         \"Service\": \"cloudtrail.amazonaws.com\"\n       },\n       \"Effect\": \"Allow\"\n     }\n   ]\n}\n"` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | n/a | `bool` | `true` | no |
| <a name="input_enable_cloudwatch_logs"></a> [enable\_cloudwatch\_logs](#input\_enable\_cloudwatch\_logs) | Enable sending logs to CloudWatch | `bool` | `false` | no |
| <a name="input_enable_log_file_validation"></a> [enable\_log\_file\_validation](#input\_enable\_log\_file\_validation) | Specifies whether log file integrity validation is enabled. Creates signed digest for validated contents of logs | `bool` | `true` | no |
| <a name="input_enable_logging"></a> [enable\_logging](#input\_enable\_logging) | Enable logging for the trail | `bool` | `true` | no |
| <a name="input_event_selector"></a> [event\_selector](#input\_event\_selector) | Specifies an event selector for enabling data event logging. See: https://www.terraform.io/docs/providers/aws/r/cloudtrail.html for details on this variable | <pre>list(object({<br>    include_management_events = bool<br>    read_write_type           = string<br><br>    data_resource = list(object({<br>      type   = string<br>      values = list(string)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_include_global_service_events"></a> [include\_global\_service\_events](#input\_include\_global\_service\_events) | Specifies whether the trail is publishing events from global services such as IAM to the log files | `bool` | `true` | no |
| <a name="input_insight_selector"></a> [insight\_selector](#input\_insight\_selector) | Configuration block for identifying unusual operational activity. | `list(string)` | `[]` | no |
| <a name="input_is_multi_region_trail"></a> [is\_multi\_region\_trail](#input\_is\_multi\_region\_trail) | Specifies whether the trail is created in the current region or in all regions | `bool` | `true` | no |
| <a name="input_is_organization_trail"></a> [is\_organization\_trail](#input\_is\_organization\_trail) | The trail is an AWS Organizations trail | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name CloudTrail | `string` | n/a | yes |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | n/a | `string` | `"cloudtrail"` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | Specifies the name of the Amazon SNS topic defined for notification of log file delivery | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
