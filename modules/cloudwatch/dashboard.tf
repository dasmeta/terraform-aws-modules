resource "aws_cloudwatch_dashboard" "applications" {
  dashboard_name = var.dashboard_name
  dashboard_body = file("${path.module}/${var.body_file_name}")
}
