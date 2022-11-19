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
  description = "Throughput mode for EFS, when set to provisioned also need to set `provisioned_throughput_in_mibps`"
  type        = string

  validation {
    condition     = contains(["bursting", "provisioned"], coalesce(var.throughput_mode, "bursting"))
    error_message = "Valid attributes are [bursting, provisioned]"
  }
  default = null
}

variable "tags" {
  type = map(any)
  default = {
    Provisioner = "DasMeta"
  }
}
