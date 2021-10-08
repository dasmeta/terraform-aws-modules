variable "mongodb_atlas_org_id" {
  type        = string
  description = "MongoDB Atlas organization ID"
}

variable "mongodb_atlas_public_key" {
  type        = string
  description = "Public key for the access to MongoDB Atlas"
}

variable "mongodb_atlas_private_key" {
  type        = string
  description = "Private key for the access to MongoDB Atlas"
}

variable "project_name" {
  type        = string
  default     = "project-test"
  description = "MongoDB Atlas Project Name"
}

variable "users" {
  type        = list(string)
  default     = ["alice", "mark", "soghomon", "qnqush"]
  description = "MongoDB Atlas users list"
}

variable "ip_addresses" {
  type        = list(string)
  default     = []
  description = "MongoDB Atlas IP Access List"
}

variable "aws_account_id" {
  type        = string
  description = "AWS user ID"
}

variable "mongodb_atlas_secret" {
  type      = string
  description = "value"
}
