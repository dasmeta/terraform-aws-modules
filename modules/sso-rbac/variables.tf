variable "permission_sets" {
  type = list(object({
    name               = string
    description        = string
    relay_state        = string
    session_duration   = string
    tags               = map(string)
    inline_policy      = string
    policy_attachments = list(string)
  }))

  default = []
}

variable "account_assignments" {
  type = list(object({
    account             = string
    permission_set_name = string
    permission_set_arn  = string
    principal_name      = string
    principal_type      = string
  }))
}

variable "cluster_name" {
  type = string
}
variable "cluster_region" {
  type = string
}

variable "rbac_group" {
  type = string
}

variable "group_arn" {
  type = string
}

variable "rbac_rule" {
  type = list(object({
    name           = string
    namespace      = string
    api_groups     = list(string)
    resources      = list(string)
    resource_names = list(string)
    verbs          = list(string)
  }))
}
