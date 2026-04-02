resource "random_id" "suffix" {
  byte_length = 4
}

module "this" {
  source = "../../"

  repository_name = "tf-test-codecommit"
  description     = "Terraform aws codecommit module test"
  tags = {
    Purpose = "terraform-module-test"
  }
}


