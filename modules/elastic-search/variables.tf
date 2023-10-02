variable "domain_name" {
  type        = string
  description = "The domain name of ES"
}

variable "vpc_options_subnet_ids" {
  type        = list(string)
  description = "The list of vpc subnet ids, if availability_zone_count is two you have to pass two subnet ids"
}

variable "vpc_options_security_group_whitelist_ids" {
  type        = list(string)
  default     = []
  description = "The list of security group ids to whitelist in ingress"
}

variable "vpc_options_security_group_whitelist_cidr" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "The list of security group cidr blocks to whitelist in ingress"
}

variable "es_version" {
  type        = string
  default     = "7.1"
  description = "The version of ES"
}

variable "dedicated_master_enabled" {
  type        = bool
  default     = false
  description = "Have dedicated master or not for ES"
}

variable "instance_count" {
  type        = number
  default     = 2
  description = "The number of ES node instances"
}

variable "instance_type" {
  type        = string
  default     = "t3.small.elasticsearch"
  description = "The node instance types of ES"
}

variable "zone_awareness_enabled" {
  type        = bool
  default     = true
  description = "The zone awareness of ES"
}

variable "availability_zone_count" {
  type        = number
  default     = 2
  description = "The number of availability zones of ES"
}

variable "ebs_options_ebs_enabled" {
  type        = bool
  default     = true
  description = "Whether enable EBS for ES"
}

variable "ebs_options_volume_size" {
  type        = number
  default     = 10
  description = "Storage volume size in GB"
}

variable "encrypt_at_rest_enabled" {
  type        = bool
  default     = false
  description = "Whether encrypt rest calls data"
}

variable "encrypt_at_rest_kms_key_id" {
  type        = string
  default     = "alias/aws/es"
  description = "The KMS key id to encrypt the ES domain with. If not specified then it defaults to using the aws/es service KMS key"
}

variable "node_to_node_encryption_enabled" {
  type        = bool
  default     = true
  description = "Whether to enable node to node encryption"
}

variable "snapshot_options_automated_snapshot_start_hour" {
  type        = number
  default     = 0
  description = "The amount of ours to wait to snapshot of ES db"
}

variable "access_policies" {
  type        = string
  default     = ""
  description = "Custom access policies, if not provided one being generated automatically"
}

variable "timeouts_update" {
  type        = string
  default     = null
  description = "The timeout update of ES"
}

variable "create_service_link_role" {
  description = "Create service link role for AWS Elasticsearch Service"
  type        = bool
  default     = true
}


variable "advanced_security_options_enabled" {
  description = "Whether advanced security is enabled (Forces new resource)"
  type        = bool
  default     = false
}

variable "internal_user_database_enabled" {
  description = "Whether the internal user database is enabled. If not set, defaults to false by the AWS API."
  type        = bool
  default     = false
}

variable "master_user_arn" {
  description = "ARN for the master user. Only specify if `internal_user_database_enabled` is not set or set to `false`)"
  type        = string
  default     = null
}

variable "master_user_username" {
  description = "The master user's username, which is stored in the Amazon Elasticsearch Service domain's internal database. Only specify if `internal_user_database_enabled` is set to `true`."
  type        = string
  default     = null
}

variable "master_user_password" {
  description = "The master user's password, which is stored in the Amazon Elasticsearch Service domain's internal database. Only specify if `internal_user_database_enabled` is set to `true`."
  type        = string
  default     = null
}

variable "create_random_master_password" {
  description = "Whether to create random master password for Elasticsearch master user"
  type        = bool
  default     = false
}

variable "random_master_password_length" {
  description = "Length of random master password to create"
  type        = number
  default     = 16
}
