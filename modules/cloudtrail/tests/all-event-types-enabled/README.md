# all-event-types-enabled

## How to Use
There are 3 types of CloudTrail events: Management events, Data events and Insights events.

### Data Event Logging
CloudTrail can log Data Events for certain services such as S3 objects and Lambda function invocations. This block of code is for enabling logging for two of them:
```
module "this" {
  source = "../../"
  ....
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
  ....
}
```

### Insight Event Logging
CloudTrail Insights events capture unusual API call rate or error rate activity in your AWS account. There are 2 types of insight you can log: ApiCallRateInsight and ApiErrorRateInsight.
With this list you can enable logging for these 2 types:
```
module "this" {
  source = "../../"

  ....
  insight_selectors = ["ApiCallRateInsight", "ApiErrorRateInsight"]
  ....
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.41 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_test"></a> [test](#provider\_test) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| test_assertions.dummy | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
