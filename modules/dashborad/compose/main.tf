
data "aws_region" "current" {}

locals {
  widget_data_metric = [for k, item in var.widget : {
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
  } if item.type == "metric"]

  widget_data_text = [for k, item in var.widget : {
    "type" : "text",
    "x" : 0,
    "y" : 7,
    "width" : 3,
    "height" : 3,
    "properties" : {
      "markdown" : item.markdown
    }
  } if item.type == "text"]
}

output "widget" {
  value = concat(local.widget_data_metric, local.widget_data_text)
}

output "widget_data_text" {
  value = local.widget_data_text
}
