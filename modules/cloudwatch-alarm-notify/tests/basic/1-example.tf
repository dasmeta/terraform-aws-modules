module "cloudwatchalarm" {
  source     = "../../"
  alarm_name = "alarmname"
  # Type  k8s_alerts, alb_alerts,rds_alerts,other
  alert_type_name = "k8s_alerts"

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
