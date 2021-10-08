# How to

````
module "mongodb-credentials" {
    source = "../terraform-aws-modules/modules/secret"

    mongodb_atlas_org_id = "some mongo atlas org id"
    mongodb_atlas_public_key = "mongo atlas public key"
    mongodb_atlas_private_key = "mongo atlas private key"
    project_name = "your project name goes here"
    ip_addresses = ["ip1", "ip2", "ip3", "ipN"]
    aws_account_id = "your aws account id"
    users = ["user1", "user2", "userN"]
    mongodb_atlas_secret = "your secret"
}
