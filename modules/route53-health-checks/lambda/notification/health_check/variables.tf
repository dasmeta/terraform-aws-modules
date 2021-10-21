# Slack notification variables
variable "slack_hook_url" {
  type = string
}

variable "domen_name" {
  type = string
}

variable "resource_path" {
  type = string
  description = "Path name coming after fqdn."
}