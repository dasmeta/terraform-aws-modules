locals {
  dashboards = var.dashboards["dashboards"]
  //     ${jsonencode(module.compose[each.key].widget)}
}

resource "aws_cloudwatch_dashboard" "error_metric_include2" {
  for_each = local.dashboards

  dashboard_name = each.key
  dashboard_body = <<EOF
  {
    "widgets": ${jsonencode(module.compose[each.key].widget)}
  }
  EOF
}

module "compose" {
  for_each = local.dashboards
  source   = "./compose"

  widget = each.value
}

output "widget_data_text" {
  value = jsonencode(module.compose["dashboard1"].widget)
}
