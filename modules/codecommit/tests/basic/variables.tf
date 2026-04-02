variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region where the test repository is created."
}

variable "aws_profile" {
  type        = string
  default     = null
  description = "Named profile from ~/.aws/credentials and ~/.aws/config. If null, the provider uses the default chain: env vars (e.g. AWS_ACCESS_KEY_ID), then AWS_PROFILE, then the default profile."
}
