variable "setup" {
  type        = string
  default     = "standalone"
  description = "Which mongodb setup to consider: standalone (default), replicaset."
}

variable "cluster_host" {
  type = string
}

variable "cluster_certificate" {
  type = string
}

variable "cluster_token" {
  type = string
}

variable "name" {
  type        = string
  default     = "mongodb"
  description = "Release name."
}

variable "values" {
  description = "Extra values"
  type        = list(string)
  default     = null
}

variable "set" {
  description = "Value block with custom STRING values to be merged with the values yaml."
  type = list(object({
    name  = string
    value = string
  }))
  default = null
}
variable "root_password" {
  type      = string
  sensitive = true
}

variable "replicaset_key" {
  type = string
}

variable "image_tag" {
  type    = string
  default = "4.4.11-debian-10-r5"
}

variable "persistence_size" {
  type    = string
  default = "8Gi"
}

variable "readinessprobe_initialdelayseconds" {
  type    = string
  default = "5"
}

variable "livenessprobe_initialdelayseconds" {
  type    = string
  default = "30"
}

variable "persistence_annotations" {
  default = null
}

variable "resources" {
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    limits = {
      cpu    = "300m"
      memory = "500Mi"
    }
    requests = {
      cpu    = "300m"
      memory = "500Mi"
    }
  }
  description = "Allows to set cpu/memory resources Limits/Requests for deployment."
}

variable "arbiter_resources" {
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    limits = {
      cpu    = ""
      memory = ""
    }
    requests = {
      cpu    = ""
      memory = ""
    }
  }
  description = "Allows to set cpu/memory resources Limits/Requests for arbiter."
}

variable "architecture" {
  type    = string
  default = "replicaset"
}
