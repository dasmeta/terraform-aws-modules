module "this" {
  source = "../../"

  repository_name = "tf-test-codecommit"
  description     = "Terraform aws codecommit module test"
  tags = {
    Purpose = "terraform-module-test"
  }
}
