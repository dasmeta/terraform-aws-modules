variable public_key {
  type        = string
  description = "MongoDB Atlas organisation public key"
}

variable private_key {
  type        = string
  description = "MongoDB Atlas organisation private key"
}

variable org_id {
  type        = string
  description = "MongoDB Atlas Organisation ID"
}

variable project_name {
  type        = string
  default     = "Project"
  description = "MongoDB Atlas Project Name"
}

variable users {
  type        = list(string)
  default     = ["Alice"]
  description = "MongoDB Atlas users list"
}

variable role_name {
  type        = string
  default     = "readWrite"
  description = "MongoDB Atlas users role name"
}

variable database_name {
  type        = string
  default     = "Database"
  description = "MongoDB Atlas users database name"
}

variable ip_addresses {
  type        = list(string)
  default     = [""]
  description = "MongoDB Atlas IP Access List"
}
