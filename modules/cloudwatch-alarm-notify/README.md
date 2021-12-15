Module use examples.

# Example 1

In this case, you can create alarm default parameters using only alert type.

module "cloudwatchalarm" {
    source           = "../../terraform-aws-modules/modules/cloudwatch-alarm-notify"
    alarm_name       = "alarmname"
    # Three type alerts k8s_alerts, alb_alerts, other_alerts
    alert_type_name  = "k8s_alerts"

    # Slack information
    slack_hook_url = ""
    slack_channel  = ""
    slack_username = ""
}

# Example 2

In this case, you can create alarm to override default parameters.

module "cloudwatchalarm" {
    source           = "../../terraform-aws-modules/modules/cloudwatch-alarm-notify"
    alarm_name       = "alarmname"
    
    # Three type alert k8s_alerts, alb_alerts, other_alerts
    alert_type_name  = "k8s_alerts"
    
    # All variables include 
    alert_variables  = {
        # Alert type name and variables value 
        k8s_alerts = {
          comparison_operator    = "GreaterThanOrEqualToThreshold"
          evaluation_periods     = "1"
          period                 = "300"
          namespace              = "ContainerInsights"
          unit                   = "Percent"
          metric_name            = "pod_cpu_utilization"
          statistic              = "Average"
          threshold              = "25"
          alarm_description_up   = "Pod mongodb-replicaset-prod-0 CPU usage < 25"
          alarm_description_down = "Pod mongodb-replicaset-prod-0 CPU usage > 25"
          treat_missing_data     = "notBreaching"
          dimensions             = {
            "ClusterName" = "prod-6"
            "PodName"     = "mongodb-replicaset-prod-0"
            "Namespace"   = "default"
        }
          insufficient_data_actions = []
      }
    }

    # Slack information
    slack_hook_url   = ""
    slack_channel    = ""
    slack_username   = ""
}

# Example 3

This case you can create alarm not implemented case.

module "cloudwatchalarm" {
    source           = "../../terraform-aws-modules/modules/cloudwatch-alarm-notify"
    alarm_name       = "alarmname"
    
    # Three type alert k8s_alerts, alb_alerts, other_alerts
    alert_type_name  = "other_alerts"
    
    # All variables include 
    alert_variables  = {
        # Alert type name and variables values 
        other_alerts = {
          comparison_operator    = ""
          evaluation_periods     = ""
          period                 = ""
          namespace              = ""
          unit                   = ""
          metric_name            = ""
          statistic              = ""
          threshold              = ""
          alarm_description_up   = ""
          alarm_description_down = ""
          treat_missing_data     = ""
          dimensions             = {}
          insufficient_data_actions = []
      }
    }
    
    # Slack information
    slack_hook_url   = ""
    slack_channel    = ""
    slack_username   = ""
}