locals {
    dimensions = {
        "ClusterName" = var.cluster_name
        "PodName"     = var.pod_name
        "Namespace"   = var.namespace
    }

    metric_cpu    = module.cloudwatchalarm_cpu.metric_name
    namespace_cpu = module.cloudwatchalarm_cpu.namespace

    metric_memory    = module.cloudwatchalarm_memory.metric_name
    namespace_memory = module.cloudwatchalarm_memory.namespace

    metric_error    = var.error_filter ? module.cloudwatchalarm_error.metric_name : ""
    namespace_error = var.error_filter ? module.cloudwatchalarm_error.namespace : ""

    metric_network_tx    = module.cloudwatchalarm_network_tx.metric_name
    namespace_network_tx = module.cloudwatchalarm_network_tx.namespace

    metric_network_rx    = module.cloudwatchalarm_network_rx.metric_name
    namespace_network_rx = module.cloudwatchalarm_network_rx.namespace

}

// CPU ALARM 
module "cloudwatchalarm_cpu" {
    source           = "../cloudwatch-alarm-notify"
    alarm_name       = "${var.pod_name}_cpu_utilization"

    comparison_operator    = "GreaterThanOrEqualToThreshold"
    evaluation_periods     = "1"
    period                 = "300"
    namespace              = "ContainerInsights"
    unit                   = "Percent"
    metric_name            = "pod_cpu_utilization"
    statistic              = "Average"
    threshold              = var.cpu_threshold
    treat_missing_data     = "notBreaching"
    dimensions             = local.dimensions

    # Slack information
    slack_hook_url   = var.slack_hook_url
    slack_channel    = var.slack_channel
    slack_username   = var.slack_username

    # SNS Topic 
    sns_subscription_email_address_list = var.sns_subscription_email_address_list
    sns_subscription_phone_number_list  = var.sns_subscription_phone_number_list
    sms_message_body                    = var.sms_message_body
}

// MEMORY ALARM 
module "cloudwatchalarm_memory" {
    source           = "../cloudwatch-alarm-notify"
    alarm_name       = "${var.pod_name}_memory_utilization"

    comparison_operator    = "GreaterThanOrEqualToThreshold"
    evaluation_periods     = "1"
    period                 = "300"
    namespace              = "ContainerInsights"
    unit                   = "Percent"
    metric_name            = "pod_memory_utilization"
    statistic              = "Average"
    threshold              = var.memory_threshold
    treat_missing_data     = "notBreaching"
    dimensions             = local.dimensions

    # Slack information
    slack_hook_url   = var.slack_hook_url
    slack_channel    = var.slack_channel
    slack_username   = var.slack_username

    # SNS Topic 
    sns_subscription_email_address_list = var.sns_subscription_email_address_list
    sns_subscription_phone_number_list  = var.sns_subscription_phone_number_list
    sms_message_body                    = var.sms_message_body
}

// Log Filter 
module "cloudwatch_log_metric_filter" {
    count = var.error_filter ? 1 : 0
    source = "../cloudwatch-log-metric"

    name             = var.pod_name
    filter_pattern   = "Error"
    create_log_group = false
    log_group_name   = var.log_group_name
    metric_name      = "errorfilter"
}

// Error Metric
module "cloudwatchalarm_error" {
    count = var.error_filter ? 1 : 0
    source           = "../cloudwatch-alarm-notify"
    alarm_name       = "${var.pod_name}_error_utilization"

    comparison_operator    = "GreaterThanOrEqualToThreshold"
    evaluation_periods     = "1"
    period                 = "60"
    namespace              = "LogGroupFilter"
    unit                   = "Percent"
    metric_name            = "errorfilter"
    statistic              = "Sum"
    threshold              = var.error_threshold
    treat_missing_data     = "notBreaching"
    dimensions             = local.dimensions

    # Slack information
    slack_hook_url   = var.slack_hook_url
    slack_channel    = var.slack_channel
    slack_username   = var.slack_username

    # SNS Topic 
    sns_subscription_email_address_list = var.sns_subscription_email_address_list
    sns_subscription_phone_number_list  = var.sns_subscription_phone_number_list
    sms_message_body                    = var.sms_message_body
}

// Network Metric
module "cloudwatchalarm_network_tx" {
    source           = "../cloudwatch-alarm-notify"
    alarm_name       = "${var.pod_name}_network_tx_utilization"

    comparison_operator    = "GreaterThanOrEqualToThreshold"
    evaluation_periods     = "1"
    period                 = "300"
    namespace              = "ContainerInsights"
    unit                   = "Percent"
    metric_name            = "pod_network_tx_bytes"
    statistic              = "Average"
    threshold              = var.network_threshold
    treat_missing_data     = "notBreaching"
    dimensions             = local.dimensions

    # Slack information
    slack_hook_url   = var.slack_hook_url
    slack_channel    = var.slack_channel
    slack_username   = var.slack_username

    # SNS Topic 
    sns_subscription_email_address_list = var.sns_subscription_email_address_list
    sns_subscription_phone_number_list  = var.sns_subscription_phone_number_list
    sms_message_body                    = var.sms_message_body
}

module "cloudwatchalarm_network_rx" {
    source           = "../cloudwatch-alarm-notify"
    alarm_name       = "${var.pod_name}_network_rx_utilization"

    comparison_operator    = "GreaterThanOrEqualToThreshold"
    evaluation_periods     = "1"
    period                 = "300"
    namespace              = "ContainerInsights"
    unit                   = "Percent"
    metric_name            = "pod_network_rx_bytes"
    statistic              = "Average"
    threshold              = var.network_threshold
    treat_missing_data     = "notBreaching"
    dimensions             = local.dimensions

    # Slack information
    slack_hook_url   = var.slack_hook_url
    slack_channel    = var.slack_channel
    slack_username   = var.slack_username
    
    # SNS Topic 
    sns_subscription_email_address_list = var.sns_subscription_email_address_list
    sns_subscription_phone_number_list  = var.sns_subscription_phone_number_list
    sms_message_body                    = var.sms_message_body
}

// Pod Restarts 
module "cloudwatchalarm_restart_count" {
    source           = "../cloudwatch-alarm-notify"
    alarm_name       = "${var.pod_name}_restart_count"

    comparison_operator    = "GreaterThanThreshold"
    evaluation_periods     = "1"
    period                 = "60"
    namespace              = "ContainerInsights"
    unit                   = "Count"
    metric_name            = "pod_number_of_container_restarts"
    statistic              = "Average"
    threshold              = var.restart_count
    treat_missing_data     = "notBreaching"
    dimensions             = local.dimensions

    # Slack information
    slack_hook_url   = var.slack_hook_url
    slack_channel    = var.slack_channel
    slack_username   = var.slack_username

    # SNS Topic 
    sns_subscription_email_address_list = var.sns_subscription_email_address_list
    sns_subscription_phone_number_list  = var.sns_subscription_phone_number_list
    sms_message_body                    = var.sms_message_body
}

resource "aws_cloudwatch_dashboard" "all_metric_include" {
  count = var.create_dashboard ? 1 : 0
  dashboard_name = "${var.pod_name}-dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          ["ContainerInsights", "pod_cpu_utilization", "ClusterName", "${var.cluster_name}", "PodName", "${var.pod_name}", "Namespace", "${var.namespace}"]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "${var.pod_name} Pod CPU Utilization"
        }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
            ["ContainerInsights", "pod_memory_utilization", "ClusterName", "${var.cluster_name}", "PodName", "${var.pod_name}", "Namespace", "${var.namespace}"]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "${var.pod_name} Pod Memory Utilization"
        }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
            ["ContainerInsights", "pod_network_tx_bytes", "ClusterName", "${var.cluster_name}", "PodName","${var.pod_name}", "Namespace","${var.namespace}"]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "${var.pod_name} Pod Netowrk TX Utilization"
        }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
            ["ContainerInsights", "pod_number_of_container_restarts", "ClusterName", "${var.cluster_name}", "PodName","${var.pod_name}", "Namespace","${var.namespace}"]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "${var.pod_name} Pod Container restarts"
        }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
            ["ContainerInsights", "pod_network_rx_bytes", "ClusterName", "${var.cluster_name}", "PodName","${var.pod_name}", "Namespace","${var.namespace}"]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "${var.pod_name} Pod Netowrk RX Utilization"
        }
    }
  ]
}
EOF
}
resource "aws_cloudwatch_dashboard" "error_metric_include" {
  count = var.create_dashboard && var.error_filter ? 1 : 0
  dashboard_name = "${var.pod_name}-dashboard"

  dashboard_body = <<EOF
  {
    "widgets": [
      {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
            ["LogGroupFilter", "errorfilter"]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "us-east-1",
        "title": "${var.pod_name} Pod Error Count"
        }
      }
    ]
  }
  EOF
}

