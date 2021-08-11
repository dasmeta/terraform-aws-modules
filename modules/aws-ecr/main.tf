module "ecr" {
  source  = "cloudposse/ecr/aws"
  version = "0.32.2"
  for_each = { for x in var.repos : x => x }
  name  = "${each.value}"
}
variable "repos" {
  description = "0 out of 256 characters maximum (2 minimum). The name must start with a letter and can only contain lowercase letters, numbers, hyphens, underscores, and forward slashes."
  type = list
  default     = ["repo1", "repo2", "repo3"] # Please insert the repository names, then run the script.
}