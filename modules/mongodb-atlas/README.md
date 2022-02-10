# How to
1. create a Mongo Atlas organization at https://www.mongodb.com/cloud/atlas
2. setup api key at org settings section > API Keys
3. run
```
module "mongodb-atlas" {
  source = "dasmeta/modules/aws//modules/mongodb-atlas"

  org_id = "some mongo atlas or id"
  public_key = "mongo atlas public key"
  private_key = "mongo atlas private key"

  project_name = "your project name goes here"

  users = ["user1", "user2", "userN"]
  ip_addresses = ["ip1", "ip2", "ip3", "ipN"]

  access_users = [
      {
            username     = "test1@dasmeta.com"
            roles         = ["ORG_OWNER" , "ORG_BILLING_ADMIN" ]
            project_roles = ["GROUP_DATA_ACCESS_READ_WRITE"]
      },
      {
            username     = "test@gmail.com"
            roles         = ["ORG_OWNER" , "ORG_BILLING_ADMIN" ]
            project_roles = ["GROUP_DATA_ACCESS_READ_WRITE"]
      }
  ]
}
```

## Issues
mongodbatlas_cloud_provider_snapshot_backup_policy resource requires access through an access list of IP ranges. To solve this problem you need to 
1. open Organization -> Settings and set Require IP Access List for Public API ON,
2. add the source IP in the API key access list:
   Organization -> Access Manager -> API Keys -> Edit API key permissions -> Next -> ADD ACCESS LIST ENTRY -> Add your source IP
   (to do so you can also add your current IP address as a source one).

## Tips
1. To turn some policy_items off in mongodbatlas_cloud_backup_schedule, you need to pass "" to retention_unit. For example, if var.policy_item_hourly.retention_unit = "" then policy_item_hourly is not created.
2. mongodbatlas_cloud_provider_snapshot_backup_policy resource is deprecated but if there is a need to use it, make use_cloud_provider_snapshot_backup_policy true.
3. There is a problem in MongoDB provider with invitations for users. You can make them by this module, but it'll be better to delete mongodbatlas_org_invitation and mongodbatlas_project_invitation resources from the state.
