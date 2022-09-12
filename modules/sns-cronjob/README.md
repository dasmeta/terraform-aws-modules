## Description

This module creates cronjob based aws SNS and Cloudwatch services. It will send POST requests with input data as body "Message" json field value to specified endpoint.

### NOTE: To activate cronjob you will need to send get request using "SubscribeURL" field value which aws SNS sends as initial POST request to specified endpoint

## minimal params passing sample

```terraform
module my_cronjob {
  source = "dasmeta/modules/aws//modules/sns-cronjob"
  version = "XX.YY.ZZ"

  name = "test-cron"
  endpoint = "https://example.com/my-cron-endpoint"
}
```

## all params passing sample

```terraform
module my_cronjob {
  source = "dasmeta/modules/aws//modules/sns-cronjob"
  version = "XX.YY.ZZ"

  name = "test-cron"
  endpoint = "https://example.com/my-cron-endpoint"
  schedule = "cron(0 0/1 * * ? *)"
  input    = jsonencode({
    data = "some-data"
  })
  success_sample_percentage = 0
}
```

## Requirements

| Name                                                   | Version  |
| ------------------------------------------------------ | -------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | ~> 3.5.0 |

## Providers

| Name                                             | Version  |
| ------------------------------------------------ | -------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | ~> 3.5.0 |

## Resources

| Name                                                                                                                                                 | Type     |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_cloudwatch_event_rule.check-scheduler-event](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target)               | resource |
| [aws_sns_topic.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic)                                       | resource |

## Inputs

| Name                                                                                       | Description                                                                                                                                                                                                                                          | Type     | Default               | Required |
| ------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | --------------------- | :------: |
| <a name="input_name"></a> [name](#input_name)                                              | Name (e.g. app or cluster).                                                                                                                                                                                                                          | `string` | `""`                  |    no    |
| <a name="input_schedule_expression"></a> [schedule_expression](#input_schedule_expression) | the aws cloudwatch event rule scheule expression that specifies when the scheduler runs. Default is 5 minuts past the hour. for debugging use 'rate(5 minutes)'. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html | `any`    | `"cron(* * * * ? *)"` |    no    |

## Outputs

| Name                                         | Description                              |
| -------------------------------------------- | ---------------------------------------- |
| <a name="output_arn"></a> [arn](#output_arn) | The ARN of the SNS platform application. |
| <a name="output_id"></a> [id](#output_id)    | The ID of the SNS platform application.  |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_role.logger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.cw_event_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sqs_queue.dead_letter_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | The endpoint to send POST request data to, the contents will vary with the protocol. | `string` | n/a | yes |
| <a name="input_input"></a> [input](#input\_input) | The data, input to set into POST request body Message field. | `any` | `{}` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Controls if cronjob enabled or not | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name (e.g. app or cluster). | `string` | n/a | yes |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | the aws cloudwatch event rule schedule expression that specifies when the scheduler runs. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html | `any` | `"cron(* * * * ? *)"` | no |
| <a name="input_success_sample_percentage"></a> [success\_sample\_percentage](#input\_success\_sample\_percentage) | Percentage of success to sample | `string` | `100` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_topic_arn"></a> [topic\_arn](#output\_topic\_arn) | The ARN of the SNS platform application. |
| <a name="output_topic_id"></a> [topic\_id](#output\_topic\_id) | The ID of the SNS platform application. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_role.logger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.cw_event_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.user_updates_sqs_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sqs_queue.dead_letter_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | The endpoint to send POST request data to, the contents will vary with the protocol. | `string` | n/a | yes |
| <a name="input_input"></a> [input](#input\_input) | The data, input to set into POST request body Message field. | `any` | `""` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Controls if cronjob enabled or not | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name (e.g. app or cluster). | `string` | n/a | yes |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | the aws cloudwatch event rule schedule expression that specifies when the scheduler runs. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html | `any` | `"cron(* * * * ? *)"` | no |
| <a name="input_success_sample_percentage"></a> [success\_sample\_percentage](#input\_success\_sample\_percentage) | Percentage of success to sample | `string` | `100` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_topic_arn"></a> [topic\_arn](#output\_topic\_arn) | The ARN of the SNS platform application. |
| <a name="output_topic_id"></a> [topic\_id](#output\_topic\_id) | The ID of the SNS platform application. |
<!-- END_TF_DOCS -->