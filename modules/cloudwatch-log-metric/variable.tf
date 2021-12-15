variable "name" {
    type        = string
    description = "Name for the metric filter"
}

variable "filter_pattern" {
    type        = string
    description = "A valid CloudWatch Logs filter pattern for extracting metric data out of ingested log events."
}

variable "create_log_group" {
    type        = bool
    description = "The name of the log group to associate the metric filter with."
}

variable "log_group_name" {
    type        = string
    description = "The name of the log group to associate the metric filter with."
}

variable "metric_transformation_name" {
    type        = string
    description = "The name of the CloudWatch metric to which the monitored log information should be published ."
}

variable "metric_transformation_namespace" {
    type        = string
    description = "The destination namespace of the CloudWatch metric"
}

variable "metric_transformation_unit" {
    type        = string
    description = "(Optional) The unit to assign to the metric. If you omit this, the unit is set as None"
    default     = "None"
}

variable "metric_transformation_value" {
    type        = string
    description = "What to publish to the metric. For example, if you're counting the occurrences of a particular term like 'Error', the value will be '1' for each occurrence. If you're counting the bytes transferred the published value will be the value in the log event."
}
