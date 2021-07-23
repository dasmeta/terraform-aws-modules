variable "repo" {
  description = "<b>Create repository list.\nPlease insert the repository names\nexample 1: [\"service1\"]\nexample 2: [\"service1\", \"service2\", \"serviceN\"]\n\n0 out of 256 characters maximum (2 minimum). The name must start with a letter and can only contain lowercase letters, numbers, hyphens, underscores, and forward slashes."
  type = list
# default     = ["nginx", "jankins", "apache"]
}
