resource "random_id" "suffix" {
  byte_length = 4
}

module "this" {
  source = "../../"

  repository_name = "tf-test-codecommit-${random_id.suffix.hex}"
  description     = "Terraform aws codecommit module test"
  tags = {
    Purpose = "terraform-module-test"
  }
}

check "repository_outputs" {
  assert {
    condition     = startswith(module.this.repository_arn, "arn:aws:codecommit:")
    error_message = "repository_arn must be a CodeCommit ARN"
  }

  assert {
    condition     = startswith(module.this.clone_url_http, "https://")
    error_message = "clone_url_http must use HTTPS"
  }

  assert {
    condition     = startswith(module.this.clone_url_ssh, "ssh://")
    error_message = "clone_url_ssh must use an SSH git URL"
  }
}
