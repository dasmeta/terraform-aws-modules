# This module allows to create aws sqs and iam user with specific queue data/message pull/push/purge/delete accesses

## minimal example
```hcl
module "sqs" {
  source  = "dasmeta/modules/aws//modules/aws-iam-user"

  name       = "pdf-processing-queue-${var.env}"
}
```
