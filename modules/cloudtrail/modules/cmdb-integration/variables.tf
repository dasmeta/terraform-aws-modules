variable "name" {
  type        = string
  description = "Lambda name"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket for s3 subscription"
}

variable "cmdb_integration" {
  type = object({
    config = optional(object({
      subscriptions = optional(list(object({
        protocol               = optional(string, null)
        endpoint               = optional(string, null)
        endpoint_auto_confirms = optional(bool, false)
      dead_letter_queue_arn = optional(string) })), [])
    }), {})
  })
  default     = {}
  description = "CMDB Integration Configs"
}
