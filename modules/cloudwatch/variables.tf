variable "dashboard_name" {
  type        = string
  default     = "newdashboard"
  description = "Cloudwatch dashboard name"
}

variable "widgets" {
  description = "Cloudwatch widgets"
}
