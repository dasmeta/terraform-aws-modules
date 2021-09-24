# Configure the GitLab Provider
provider "gitlab" {
  token = var.token
}

terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab",
      version = "3.7.0"
    }
  }
}