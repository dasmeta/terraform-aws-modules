# How to use

```
module secret-store {
  source = "dasmeta/terraform/modules/external-secret-store"

  name = "application-secret-store"
  region = "eu-central-1"
  controller = var.env
  aws_account_id = var.aws_account_id
  aws_access_key = var.aws_access_key
  aws_access_secret = var.aws_access_secret
}
```
