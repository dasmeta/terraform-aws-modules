data "aws_ssoadmin_instances" "example" {}

data "aws_caller_identity" "current" {}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each = { for as in var.assignment : as.group => as }

  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn

  principal_id   = data.aws_identitystore_group.this[each.value.group].id
  principal_type = local.principal_type

  target_id   = data.aws_caller_identity.current.account_id
  target_type = local.target_type
}

data "aws_identitystore_group" "this" {
  for_each          = { for as in var.assignment : as.group => as }
  identity_store_id = local.identity_store_id

  filter {
    attribute_path  = local.attribute_path
    attribute_value = each.key
  }
}

locals {
  identity_store_id   = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  attribute_path      = "DisplayName"
  instance_arn        = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  principal_type      = "GROUP"
  target_id           = data.aws_caller_identity.current.account_id
  target_type         = "AWS_ACCOUNT"
  permission_set_role = module.permission_set_roles.arns_without_path
}
