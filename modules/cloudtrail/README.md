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

# Example 5: Use KMS key for security
```
module "cloudtrail" {
  source = "dasmeta/modules/aws//modules/cloudtrail/"

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
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_alerts"></a> [alerts](#module\_alerts) | dasmeta/monitoring/aws//modules/alerts | 1.20.0 |
| <a name="module_cmdb"></a> [cmdb](#module\_cmdb) | ./modules/cmdb-integration | n/a |
| <a name="module_log_metric_filter"></a> [log\_metric\_filter](#module\_log\_metric\_filter) | dasmeta/monitoring/aws//modules/cloudwatch-log-based-metrics | 1.20.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [aws_cloudtrail.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.cloudtrail_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cloudtrail_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudtrail_roles_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object_lock_configuration.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_policy.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_alerts"></a> [alerts](#input\_alerts) | Provide CloudWatch Log Metric filters | <pre>object({<br/>    sns_topic_name = optional(string, "alerts-sns-topic")<br/>    events         = optional(list(string), []) # Some possible values are: iam-user-creation-or-deletion, iam-role-creation-or-deletion, iam-policy-changes, s3-creation-or-deletion, root-account-usage, elastic-ip-association-and-disassociation and etc.<br/>  })</pre> | <pre>{<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | `null` | no |
| <a name="input_bucket_protection"></a> [bucket\_protection](#input\_bucket\_protection) | Opt-in protection for the module-owned bucket. Object Lock is irreversible and does not retroactively retain existing versions. | <pre>object({<br/>    force_destroy               = optional(bool, true)       # Preserve the legacy default; set false to prevent forced deletion of non-empty buckets.<br/>    versioning_enabled          = optional(bool, false)      # Enable versioning on the module-owned CloudTrail bucket.<br/>    governance_retention_years  = optional(number, 0)        # Default Governance retention in whole years; zero leaves Object Lock unmanaged.<br/>    governance_bypass_role_arns = optional(list(string), []) # Concrete IAM roles exempted from the Governance-bypass deny; empty denies everyone.<br/>  })</pre> | `{}` | no |
| <a name="input_cloud_watch_logs_group_arn"></a> [cloud\_watch\_logs\_group\_arn](#input\_cloud\_watch\_logs\_group\_arn) | Specifies a log group name using an Amazon Resource Name (ARN), that represents the log group to which CloudTrail logs will be delivered | `string` | `""` | no |
| <a name="input_cloud_watch_logs_group_name"></a> [cloud\_watch\_logs\_group\_name](#input\_cloud\_watch\_logs\_group\_name) | Specifies a log group name that will be created to which CloudTrail logs will be delivered | `string` | `"aws-cloudtrail-logs"` | no |
| <a name="input_cloud_watch_logs_group_retention"></a> [cloud\_watch\_logs\_group\_retention](#input\_cloud\_watch\_logs\_group\_retention) | Specifies the number of days you want to retain log events in the specified log group. | `number` | `90` | no |
| <a name="input_cloud_watch_logs_role_arn"></a> [cloud\_watch\_logs\_role\_arn](#input\_cloud\_watch\_logs\_role\_arn) | Specifies the role for the CloudWatch Logs endpoint to assume to write to a user’s log group | `string` | `""` | no |
| <a name="input_cloudtrail_assume_role_policy_document"></a> [cloudtrail\_assume\_role\_policy\_document](#input\_cloudtrail\_assume\_role\_policy\_document) | Assume role policy document. | `string` | `"{\n   \"Version\": \"2012-10-17\",\n   \"Statement\": [\n     {\n       \"Action\": \"sts:AssumeRole\",\n       \"Principal\": {\n         \"Service\": \"cloudtrail.amazonaws.com\"\n       },\n       \"Effect\": \"Allow\"\n     }\n   ]\n}\n"` | no |
| <a name="input_cmdb_integration"></a> [cmdb\_integration](#input\_cmdb\_integration) | CMDB Integration Configs | <pre>object({<br/>    enabled = optional(bool, false)<br/>    configs = optional(object({<br/>      subscriptions = optional(list(object({<br/>        protocol               = optional(string, null)<br/>        endpoint               = optional(string, null)<br/>        endpoint_auto_confirms = optional(bool, false)<br/>      dead_letter_queue_arn = optional(string) })), [])<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_create_s3_bucket"></a> [create\_s3\_bucket](#input\_create\_s3\_bucket) | n/a | `bool` | `true` | no |
| <a name="input_enable_cloudwatch_logs"></a> [enable\_cloudwatch\_logs](#input\_enable\_cloudwatch\_logs) | Enable sending logs to CloudWatch | `bool` | `false` | no |
| <a name="input_enable_log_file_validation"></a> [enable\_log\_file\_validation](#input\_enable\_log\_file\_validation) | Specifies whether log file integrity validation is enabled. Creates signed digest for validated contents of logs | `bool` | `true` | no |
| <a name="input_enable_logging"></a> [enable\_logging](#input\_enable\_logging) | Enable logging for the trail | `bool` | `true` | no |
| <a name="input_event_selector"></a> [event\_selector](#input\_event\_selector) | Specifies an event selector for enabling data event logging. See: https://www.terraform.io/docs/providers/aws/r/cloudtrail.html for details on this variable | <pre>list(object({<br/>    include_management_events = bool<br/>    read_write_type           = string<br/><br/>    data_resource = list(object({<br/>      type   = string<br/>      values = list(string)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_include_global_service_events"></a> [include\_global\_service\_events](#input\_include\_global\_service\_events) | Specifies whether the trail is publishing events from global services such as IAM to the log files | `bool` | `true` | no |
| <a name="input_insight_selectors"></a> [insight\_selectors](#input\_insight\_selectors) | Configuration block for identifying unusual operational activity. | `list(string)` | `[]` | no |
| <a name="input_is_multi_region_trail"></a> [is\_multi\_region\_trail](#input\_is\_multi\_region\_trail) | Specifies whether the trail is created in the current region or in all regions | `bool` | `true` | no |
| <a name="input_is_organization_trail"></a> [is\_organization\_trail](#input\_is\_organization\_trail) | The trail is an AWS Organizations trail | `bool` | `false` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key to use for encryption of cloudtrail. If no ARN is provided cloudtrail won't be encrypted. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name CloudTrail | `string` | n/a | yes |
| <a name="input_s3_key_prefix"></a> [s3\_key\_prefix](#input\_s3\_key\_prefix) | n/a | `string` | `"cloudtrail"` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | Specifies the name of the Amazon SNS topic defined for notification of log file delivery | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Existing-bucket protection

Set `bucket_protection` to protect the module-owned audit bucket without changing its resource address:

```hcl
bucket_protection = {
  force_destroy              = false
  versioning_enabled         = true
  governance_retention_years = 5
  governance_bypass_role_arns = ["arn:aws:iam::123456789012:role/example-audit-emergency"]
}
```

Defaults preserve existing behavior: forced destruction remains enabled, versioning is unmanaged and Governance years are zero (Object Lock unmanaged). Governance requires versioning and `force_destroy=false`. Exception ARNs must identify concrete roles; an empty list denies every principal permission to bypass Governance. The exception is not an IAM Allow: the role separately needs narrow bypass/version permissions and an operational approval procedure. Policy administrators remain privileged and must follow change control.

Only module-owned buckets are configured. `create_s3_bucket=false` never takes ownership of an external bucket; it does not provide a state-migration mechanism. Standalone configuration resources enable versioning before Object Lock. The bucket-level `object_lock_enabled` argument is deliberately unset to avoid provider5 replacement behavior. Review an existing-state zero-replacement plan before any apply; mocks cannot establish that property for live state.

Object Lock enablement cannot be undone and versioning cannot subsequently be suspended. Removing the Terraform lock resource removes the default retention rule, not the bucket's Object Lock capability. Default retention applies to new versions only; protect historical versions through a separately reviewed manifest/process. Never automatically shorten retention as rollback. AWS recommends allowing versioning to propagate before object operations; verify CloudTrail delivery and digest validation during rollout. Storage use/cost increases with retained versions.

For local verification, run `terraform init -backend=false`, `terraform validate`, then `terraform test -filter=tests/bucket_protection.tftest.hcl` from this module directory with Terraform >=1.7. Tests use mocked AWS providers and do not call AWS APIs. Use an AWS5 provider selection when validating this consumer path. See `examples/bucket-protection` for independently expressed usage.
