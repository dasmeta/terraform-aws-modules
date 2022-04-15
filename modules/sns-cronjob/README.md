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
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`). | `list(any)` | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | The description for the rule. | `string` | `""` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | The display name for the SNS topic. | `string` | `""` | no |
| <a name="input_enable_topic"></a> [enable\_topic](#input\_enable\_topic) | Boolean indicating whether or not to create topic. | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Boolean indicating whether or not to create sns module. | `bool` | `true` | no |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | The endpoint to send data to, the contents will vary with the protocol. | `string` | `""` | no |
| <a name="input_endpoint_auto_confirms"></a> [endpoint\_auto\_confirms](#input\_endpoint\_auto\_confirms) | Boolean indicating whether the end point is capable of auto confirming subscription. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment. | `string` | `""` | no |
| <a name="input_id"></a> [id](#input\_id) | The ARN of the SNS topic | `string` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name (e.g. app or cluster). | `string` | `""` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The fully-formed AWS policy as JSON. For more information about building AWS IAM policy documents with Terraform. | `string` | `""` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | The protocol to use. The possible values for this are: sqs, sms, lambda, application. | `string` | `""` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-sns"` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | the aws cloudwatch event rule scheule expression that specifies when the scheduler runs. Default is 5 minuts past the hour. for debugging use 'rate(5 minutes)'. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html | `any` | `"cron(* * * * ? *)"` | no |
| <a name="input_subscribers"></a> [subscribers](#input\_subscribers) | Required configuration for subscibres to SNS topic. | <pre>map(object({<br>    protocol = string<br>    endpoint = string<br>    endpoint_auto_confirms = bool <br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the SNS platform application. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the SNS platform application. |
