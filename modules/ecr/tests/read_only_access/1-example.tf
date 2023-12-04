module "this" {
  source = "../../"

  repos = [
    "test-first",
    "test-second"
  ]

  principals_readonly_access = [
    "account_id"
  ]
}
