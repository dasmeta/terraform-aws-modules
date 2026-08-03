locals {
  # Secret store names may contain "/"; IAM role names may not, so sanitize.
  sanitized_name = replace(var.name, "/", "-")

  # Role name must start with store_role_name_prefix so the controller's wildcard
  # sts:AssumeRole grant (role/<prefix>*) covers it. `prefix` adds per-region uniqueness.
  role_name = "${var.store_role_name_prefix}${var.prefix}${local.sanitized_name}"

  # `.name` rather than `.region`: the `region` attribute only exists from AWS provider 6.0,
  # and this module's constraint still allows 5.x. Consumers pairing this with the dasmeta EKS
  # module resolve to 5.x today, since that module caps the provider below 6.0.
  region = var.region != "" ? var.region : data.aws_region.current.name
}
