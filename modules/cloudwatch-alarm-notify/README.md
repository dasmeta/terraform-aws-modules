Module use examples.

# Example 1

In this case, you can create alarm default parameters using only alert type.
```
module "cloudwatchalarm" {
    source           = "dasmeta/modules/aws//modules/cloudwatch-alarm-notify"
    alarm_name       = "alarmname"
    # Type  k8s_alerts, alb_alerts
    alert_type_name  = "k8s_alerts"

    dimensions = {
        "ClusterName" = ""
        "PodName"     = ""
        "Namespace"   = ""
    }
    # Slack information
    slack_hook_url = ""
    slack_channel  = ""
    slack_username = ""

    #Opsgenie integration url
    opsgenie_endpoint = [""]
}
```
# Example 2

In this case, you can create alarm to override default parameters.
```
module "cloudwatchalarm" {
    source           = "dasmeta/modules/aws//modules/cloudwatch-alarm-notify"
    alarm_name       = "alarmname"
    
    # Type  k8s_alerts, alb_alerts
    alert_type_name  = "alb_alerts"
    threshold        = "50"

    # Slack information
    slack_hook_url   = ""
    slack_channel    = ""
    slack_username   = ""

    #Opsgenie integration url
    opsgenie_endpoint = [""]
}
```
# Example 3

This case you can create alarm not implemented case.
```
module "cloudwatchalarm" {
    source           = "dasmeta/modules/aws//modules/cloudwatch-alarm-notify"
    alarm_name       = "alarmname"
    
    
    # Variables
    comparison_operator    = "GreaterThanOrEqualToThreshold"
    evaluation_periods     = "1"
    period                 = "300"
    namespace              = "ContainerInsights"
    unit                   = "Percent"
    metric_name            = "pod_cpu_utilization"
    statistic              = "Average"
    threshold              = "50"
    treat_missing_data     = "notBreaching"
    dimensions             = {}
    insufficient_data_actions = [] 
    
    # Slack information
    slack_hook_url   = ""
    slack_channel    = ""
    slack_username   = ""

    #Opsgenie integration url
    opsgenie_endpoint = [""]
}
```
