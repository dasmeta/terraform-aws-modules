module "elastic_search" {
  source  = "lgallard/elasticsearch/aws"
  version = "0.14.1"

  domain_name           = var.domain_name
  elasticsearch_version = var.es_version

  cluster_config = {
    dedicated_master_enabled = var.dedicated_master_enabled
    instance_count           = var.instance_count
    instance_type            = var.instance_type
    zone_awareness_enabled   = var.zone_awareness_enabled
    availability_zone_count  = var.availability_zone_count
  }

  ebs_options = {
    ebs_enabled = var.ebs_options_ebs_enabled
    volume_size = var.ebs_options_volume_size
  }

  encrypt_at_rest = {
    enabled    = var.encrypt_at_rest_enabled
    kms_key_id = var.encrypt_at_rest_kms_key_id
  }

  vpc_options = {
    subnet_ids         = var.vpc_options_subnet_ids
    security_group_ids = aws_security_group.elastic_search_sg.*.id
  }

  node_to_node_encryption_enabled                = var.node_to_node_encryption_enabled
  snapshot_options_automated_snapshot_start_hour = var.snapshot_options_automated_snapshot_start_hour

  access_policies = var.access_policies != "" ? var.access_policies : templatefile("${path.module}/templates/access_policies.tpl", {
    region      = data.aws_region.current.name,
    account     = data.aws_caller_identity.current.account_id,
    domain_name = var.domain_name
  })

  timeouts_update          = var.timeouts_update
  create_service_link_role = var.create_service_link_role


  advanced_security_options_enabled                        = var.advanced_security_options_enabled
  advanced_security_options_internal_user_database_enabled = var.advanced_security_options_internal_user_database_enabled
  advanced_security_options_master_user_arn                = var.advanced_security_options_master_user_arn
  advanced_security_options_master_user_username           = var.advanced_security_options_master_user_username
  advanced_security_options_master_user_password           = var.advanced_security_options_master_user_password
  advanced_security_options_create_random_master_password  = var.advanced_security_options_create_random_master_password
  advanced_security_options_random_master_password_length  = var.advanced_security_options_random_master_password_length

}


resource "aws_security_group" "elastic_search_sg" {
  count = length(data.aws_subnet.selected)

  name        = "${var.domain_name}-es-sg"
  description = "${var.domain_name} ElasticSearch security group to control inbound/outbound traffic"
  vpc_id      = data.aws_subnet.selected[0].vpc_id

  ingress {
    cidr_blocks      = var.vpc_options_security_group_whitelist_cidr
    description      = "ElasticSearch ${var.domain_name} allow access from"
    from_port        = 443
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = var.vpc_options_security_group_whitelist_ids
    self             = false
    to_port          = 443
  }
}
