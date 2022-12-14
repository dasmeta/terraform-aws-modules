variable "repos" {
  description = "0 out of 256 characters maximum (2 minimum). The name must start with a letter and can only contain lowercase letters, numbers, hyphens, underscores, and forward slashes."
  type        = list(string)
  default     = [] # Please insert the repository names, then run the script.
}
