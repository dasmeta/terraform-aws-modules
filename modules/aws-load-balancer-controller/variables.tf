data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

// s3 bucket configs for ALB
data "aws_elb_service_account" "main" {}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "eks cluster name"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "namespace load balancer controller should be deployed into"
}

variable "create_namespace" {
  type        = bool
  default     = false
  description = "wether or no to create namespace"
}

variable "eks_oidc_root_ca_thumbprint" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "create_alb_log_bucket" {
  type        = bool
  default     = false
  description = "wether or no to create alb s3 logs bucket"
}

variable "alb_log_bucket_name" {
  type = string
  default = "ingress-logs-bucket"
}

variable "alb_log_bucket_prefix" {
  type = string
  default = ""
}

variable "region" {
  type = string
  default = "eu-central-1"
  description = "Default region"
}

# Auth data

variable "cluster_host" {
  type = string
}

variable "cluster_certificate" {
  type = string
}

variable "cluster_token" {
  type = string
}

## AWS load  balancer controller varibles
variable "function_name" {
  type    = string
  default = ""
}

variable "bucket_name" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "memory_size" {
  description = "Memory size for Lambda function"
  type        = number
  default     = null
}

variable "timeout" {
  description = "Timeout for Lambda function"
  type        = number
  default     = null
}

variable "create_alarm" {
  type    = bool
  default = false
}

variable "alarm_actions" {
  type    = list(string)
  default = []
}

variable "ok_actions" {
  type    = list(string)
  default = []
}

