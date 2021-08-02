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
  description = "MongoDB Atlas Project Name"
}

variable users {
  type        = list(string)
  description = "MongoDB Atlas users list"
}