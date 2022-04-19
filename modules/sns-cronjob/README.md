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
| <a name="input_name"></a> [name](#input\_name) | Name (e.g. app or cluster). | `string` | `""` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | the aws cloudwatch event rule scheule expression that specifies when the scheduler runs. Default is 5 minuts past the hour. for debugging use 'rate(5 minutes)'. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html | `any` | `"cron(* * * * ? *)"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the SNS platform application. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the SNS platform application. |
