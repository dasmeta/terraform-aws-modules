variable "info_title" {
  type    = string
  default = "api-gw"
}

variable "info_version" {
  type    = string
  default = "1.0"
}

variable "name" {
  type    = string
  default = "api-gw"
}

variable "endpoint_config_type" {
  type = string
  default = "REGIONAL"
}

variable "stage_name" {
  type = string
  default = "api-stage"
}