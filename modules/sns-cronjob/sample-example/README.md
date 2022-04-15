<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.5.0 |


## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.check-scheduler-event](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_sns_topic.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description for the rule. | `string` | `""` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Boolean indicating whether or not to create sns module. | `bool` | `true` | no |
| <a name="input_id"></a> [id](#input\_id) | The ARN of the SNS topic | `string` | `true` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | the aws cloudwatch event rule scheule expression that specifies when the scheduler runs. Default is 5 minuts past the hour. for debugging use 'rate(5 minutes)'. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html | `any` | `"cron(* * * * ? *)"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the SNS platform application. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the SNS platform application. |
