locals {
  # Secret store names may contain "/"; IAM role names may not, so sanitize.
  sanitized_name = replace(var.name, "/", "-")

  # Role name must start with store_role_name_prefix so the controller's wildcard
  # sts:AssumeRole grant (role/<prefix>*) covers it. `prefix` adds per-region uniqueness.
  role_name = "${var.store_role_name_prefix}${var.prefix}${local.sanitized_name}"

  region = var.region != "" ? var.region : data.aws_region.current.region
}
