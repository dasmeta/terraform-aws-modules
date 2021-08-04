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

## Issues
mongodbatlas_cloud_provider_snapshot_backup_policy resource requires access through an access list of IP ranges. To solve this problem you need to 
1. open Organization -> Settings and set Require IP Access List for Public API ON,
2. add the source IP in the API key access list:
   Organization -> Access Manager -> API Keys -> Edit API key permissions -> Next -> ADD ACCESS LIST ENTRY -> Add your source IP
   (to do so you can also add your current IP address as a source one).