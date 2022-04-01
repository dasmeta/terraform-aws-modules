variable "name" {
  type        = string
  description = "Name"
}
variable "alb_arn" {
  type        = string
  description = "Application Load Balancer ARN"
  default     = ""
}

variable "alb_arn_list" {
  type        = list(string)
  description = "Application Load Balancer ARN list"
  default     = []
}

variable "scope" {
  type        = string
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider."
  default     = "REGIONAL"
}

variable "create_alb_association" {
  type        = bool
  description = "Whether to create alb association with WAF web acl"
  default     = false
}
variable "allow_default_action" {
  type        = bool
  description = "Set to true for WAF to allow requests by default. Set to false for WAF to block requests by default."
  default     = true
}
variable "visibility_config" {
  type        = any
  description = "Visibility config for WAFv2 web acl. https://www.terraform.io/docs/providers/aws/r/wafv2_web_acl.html#visibility-configuration"
  default     = { metric_name = "test-waf-setup-waf-main-metrics" }
}
variable "rules" {
  type        = any
  description = "List of WAF rules."
  default     = []
}
variable "tags" {
  type        = any
  description = "List of WAF rules."
  default     = {}
}
