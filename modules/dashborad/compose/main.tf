
data "aws_region" "current" {}

locals {
  widget_data = [for k, item in var.widget : {
    "type" : "metric",
    "x" : 0,
    "y" : 0,
    "width" : 12,
    "height" : 6,
    "properties" : {
      "metrics" : [
        split("/", item.source)
      ],
      "period" : item.period,
      "stat" : item.statistic,
      "region" : data.aws_region.current.name,
      "title" : item.name
    }
  }]
}

output "widget" {
  value = local.widget_data
}
