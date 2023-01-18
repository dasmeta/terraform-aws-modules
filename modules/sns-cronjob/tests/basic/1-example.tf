module "my_cronjob" {
  source = "../../"

  name     = "test-cron"
  endpoint = "https://example.com/my-cron-endpoint"
}
