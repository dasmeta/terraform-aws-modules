## Example
```
module "postgres" {
  source     = "../../../../dasmeta/terraform/modules/aws-rds-postgres"
  name       = "instance"
  database   = "database"
  username   = "username"

  vpc_id     = var.vpc_id # vpc-745836783
  subnet_ids = var.vpc_subnet_ids # ["subnet-457845", "subnet-54875787"]
}