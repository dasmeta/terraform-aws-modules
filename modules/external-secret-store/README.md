# How to use

```
module "secret-store" {
  source = "dasmeta/terraform/modules/external-secret-store"

  name = "store-name"
}
```
This is going to create AWS IAM User and restric access to Secret Manager keys starting with store-name (e.g. store-name-*).
Any secret created in Secret Manager matching the prefix can be requested via that External Secret Store and be populated as a Secret.
