# How to
1. create a Mongo Atlas organisation at https://www.mongodb.com/cloud/atlas
2. setup api key at org settings section > API Keys
3. run
```
module "mongodb-atlas" {
  source = "git::https://github.com/dasmeta/terraform.git//modules/mongodb-atlas?ref=0.6.0"

  org_id = "some mongo atlas or id"
  public_key = "mongo atlas public key"
  private_key = "mongo atlas private key"

  project_name = "your project name goes here"

  users = ["user1", "user2", "userN"]
  ip_ranges = ["ip1", "ip2", "ip3", "ipN"]
}
