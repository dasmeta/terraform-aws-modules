module "this" {
  source = "../../"

  repos = [
    "test-first"
  ]

  max_image_count = 100
  protected_tags  = ["prod", "stage"]
}
