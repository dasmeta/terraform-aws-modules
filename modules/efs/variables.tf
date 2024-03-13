variable "creation_token" {
  description = "Creation token, same as unique name"
  type        = string
}

variable "availability_zone_prefix" {
  description = "Availability zone prefix, concat later to region code"
  type        = string
  default     = ""

  validation {
    condition     = contains(["a", "b", "c", "d", "e", "f", ""], var.availability_zone_prefix)
    error_message = "Valid variable parameters are those final result is us-east-1 -> a <-"
  }
}

variable "encrypted" {
  description = "Weather make encrypted or not"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "AWS kms key arn"
  type        = string
  default     = null
}

variable "performance_mode" {
  description = "Performance mode for EFS"
  type        = string
  validation {
    condition     = contains(["generalPurpose", "maxIO"], coalesce(var.performance_mode, "generalPurpose"))
    error_message = "Only these attributes are valid [generalPurpose, maxIO]"
  }
  default = null
}

variable "provisioned_throughput_in_mibps" {
  description = "Throughput mibps for EFS, Only compliant when throughput mode is set to provisioned"
  type        = string
  default     = null
}

variable "throughput_mode" {
  description = "Throughput mode for the file system. Valid values: bursting, provisioned, or elastic. When using 'provisioned', also set 'provisioned_throughput_in_mibps'."
  type        = string
  default     = "elastic"

  validation {
    condition     = contains(["bursting", "provisioned", "elastic"], var.throughput_mode)
    error_message = "The throughput_mode must be 'bursting', 'provisioned', or 'elastic'."
  }
}

variable "mount_target_subnets" {
  description = "Subnet in which to create mount target"
  type        = list(string)
  default     = []
}

variable "tags" {
  type = map(any)
  default = {
    Provisioner = "DasMeta"
  }
}

variable "lifecycle_policy" {
  description = "A block representing the lifecycle policy for the file system."
  type        = any
  default = {
    transition_to_ia                    = "AFTER_30_DAYS"
    transition_to_archive               = "AFTER_60_DAYS"
    transition_to_primary_storage_class = null // Can be set to AFTER_1_ACCESS
  }
}
