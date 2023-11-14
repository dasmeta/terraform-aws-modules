module "redis" {
  source  = "cloudposse/elasticache-redis/aws"
  version = "0.47.0"

  availability_zones                   = var.availability_zones
  zone_id                              = var.zone_id
  vpc_id                               = var.vpc_id
  allowed_security_group_ids           = var.allowed_security_group_ids
  subnets                              = var.subnets
  cluster_size                         = var.cluster_size
  cluster_mode_enabled                 = var.cluster_mode_enabled
  cluster_mode_replicas_per_node_group = var.cluster_mode_replicas_per_node_group
  cluster_mode_num_node_groups         = var.cluster_mode_num_node_groups
  instance_type                        = var.instance_type
  apply_immediately                    = var.apply_immediately
  automatic_failover_enabled           = var.automatic_failover_enabled
  engine_version                       = var.engine_version
  family                               = var.family
  port                                 = var.port
  at_rest_encryption_enabled           = var.at_rest_encryption_enabled
  transit_encryption_enabled           = var.transit_encryption_enabled
  description                          = var.description
  context = {
    enabled             = lookup(var.context, "enabled", true)
    name                = var.name
    namespace           = lookup(var.context, "namespace", null)
    tenant              = lookup(var.context, "tenant", null)
    environment         = lookup(var.context, "environment", null)
    stage               = lookup(var.context, "stage", null)
    delimiter           = lookup(var.context, "delimiter", null)
    attributes          = lookup(var.context, "attributes", [])
    tags                = lookup(var.context, "tags", {})
    additional_tag_map  = lookup(var.context, "additional_tag_map", {})
    regex_replace_chars = lookup(var.context, "regex_replace_chars", null)
    label_order         = lookup(var.context, "label_order", [])
    id_length_limit     = lookup(var.context, "id_length_limit", null)
    label_key_case      = lookup(var.context, "label_key_case", null)
    label_value_case    = lookup(var.context, "label_value_case", null)
    descriptor_formats  = lookup(var.context, "descriptor_formats", {})
  }
  #   parameter = var.parameter
}
