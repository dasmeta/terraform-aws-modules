variable "aws_account_ids" {
  type        = list(string)
  description = "AWS Account IDs who can easily view your data(CloudWatch metrics, dashboards, logs widgets)"
}
