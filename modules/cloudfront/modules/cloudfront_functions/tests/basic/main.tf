module "function" {
  source = "../../"

  name = "test"
  code = file("${path.module}/function.js")
}
