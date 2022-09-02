# Enable Cross-account cross-Region CloudWatch

### 1. Deploy module on account whose data do you want share.

```
module "aws_cloudwatch_log_metric_filter" {
    source = "dasmeta/modules/aws//modules/cloudwatch-cross-account-share-data"

    aws_account_ids = ["56*****9"]
}
```

### 2. Enable View cross-account cross-region each in monitoring account if you want to view cross-account CloudWatch data.

When you complete enable proces, CloudWatch creates a service-linked role that CloudWatch uses in the monitoring account to access data shared from your other accounts. This service-linked role is called AWSServiceRoleForCloudWatchCrossAccount. We cant create this role with terraform becouse role name have AWSServiceRole prefix.

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

| Name                                                                                                                                            | Type        |
| ----------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_role.aws-cloudwatch-metrics-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                | resource    |
| [aws_iam_role_policy_attachment.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy)                              | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                     | data source |

## Inputs

| Name                                                                           | Description                                                                                 | Type           | Default | Required |
| ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_aws_account_ids"></a> [aws_account_ids](#input_aws_account_ids) | AWS Account IDs who can easily view your data(CloudWatch metrics, dashboards, logs widgets) | `list(string)` | n/a     |   yes    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
