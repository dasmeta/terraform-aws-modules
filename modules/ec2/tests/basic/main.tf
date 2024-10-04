module "test" {
  source = "../../"

  name = "ec2-name"
  alarms = {
    sns_topic = "account-alarms-handling"
  }
}
