
## use sample

```hcl

module "healthcheck" {
  providers = {
    aws = aws.virginia
  }

  source                              = "dasmeta/modules/aws//modules/route53-alerts-notify"
  version                             = "0.16.6"

  domain_name                         = "devops.dasmeta.com"
  resource_path                       = "/"
  type                                = "HTTPS"
  port                                = "443"
  slack_hook_url                      = "{SLACK_WEBHOOK_PATH_VALUE}"
  slack_username                      = "{SLACK_USERNAME_VALUE}"
  slack_channel                       = "{SLACK_CHANNEL_NAME_VALUE}"
  sns_subscription_email_address_list = ["info@devops.dasmeta.com"]
  sns_subscription_phone_number_list  = ["+0000000000"]
  tags = {
    Name = "{HEALTH_CHECK_NAME_VALUE}"
  }
}


```