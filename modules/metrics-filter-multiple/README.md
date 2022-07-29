```
module "cloudwatch_metric_filter" {
  source = "dasmeta/modules/aws//modules/metric-filter-multiple"

  log_groups = {
    group1 = "/group/one/path"
    group2 = "/group/two/path"
    groupN = "/group/nnn/path"
  }

  patterns = [
    {
      name = "errors"
      source = "group1"
      pattern = "error"
    }
  ]

  metrics_namespace = "Log_Filters"
}
```
This results in:
Log_Filters/GroupKey/Name