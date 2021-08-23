variable public_key {
  type        = string
  description = "MongoDB Atlas organisation public key"
}

variable private_key {
  type        = string
  description = "MongoDB Atlas organisation private key"
}

variable aws_account_id {
  type        = string
  description = "AWS user ID"
}

variable org_id {
  type        = string
  description = "MongoDB Atlas Organisation ID"
}

variable project_name {
  type        = string
  default     = "project"
  description = "MongoDB Atlas Project Name"
}

variable users {
  type        = list(string)
  default     = ["alice"]
  description = "MongoDB Atlas users list"
}

variable role_name {
  type        = string
  default     = "readWrite"
  description = "MongoDB Atlas users role name"
}

variable database_name {
  type        = string
  default     = "database"
  description = "MongoDB Atlas users database name"
}

variable ip_addresses {
  type        = list(string)
  default     = []
  description = "MongoDB Atlas IP Access List"
}

variable route_table_cidr_block {
  type        = string
  default     = "192.168.240.0/21"
  description = "AWS VPC CIDR block or subnet."
}
