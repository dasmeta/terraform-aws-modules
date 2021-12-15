# This module create metric filter on CloudWatch log group.

Note.

 Metrics that have not had any new data points in the past two weeks do not appear in the console. They also do not appear when you type their metric name or dimension names in the ///search box in the All metrics tab in the console, and they are not returned in the results of a list-metrics command. The best way to retrieve these metrics is with the get-metric-data or get-metric-statistics commands in the AWS CLI. -->


## Example 1. Create Log group and metric filter.

module "aws_cloudwatch_log_metric_filter" {
    source = "dasmeta/modules/aws//modules/cloudwatch-log-group-metric-filter/"

    name             = "example"
    filter_pattern   = "ERROR"
    create_log_group = true
    log_group_name   = "/aws/example/"
    metric_transformation_name      = "metric-transformation-name"
    metric_transformation_namespace = "metric-transformation-namespace"
    metric_transformation_value     = "1"
    metric_transformation_unit      = "None"
}


## Example 2. Add metric filter existing in the log group

module "aws_cloudwatch_log_metric_filter" {
    source = "dasmeta/modules/aws//modules/cloudwatch-log-group-metric-filter/"

    name             = "example"
    filter_pattern   = "ERROR"
    create_log_group = false
    log_group_name   = "/aws/cognito/userpools/"
    metric_transformation_name      = "metric-transformation-name"
    metric_transformation_namespace = "metric-transformation-namespace"
    metric_transformation_value     = "1"
    metric_transformation_unit      = "None"
}
