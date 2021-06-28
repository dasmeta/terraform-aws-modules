# How
```
module "cognito" {
  source = "git::https://github.com/dasmeta/terraform.git//modules/cognito?ref=0.5.0"

  name = "example-pool"
  clients = ["main"]
}
