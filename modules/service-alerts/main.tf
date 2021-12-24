locals {
    dimensions = {
        "ClusterName" = var.cluster_name
        "Service"     = var.service_name
        "Namespace"   = var.namespace
    }

    metric_cpu    = module.cloudwatchalarm_cpu.metric_name
    namespace_cpu = module.cloudwatchalarm_cpu.namespace

    metric_memory    = module.cloudwatchalarm_memory.metric_name
    namespace_memory = module.cloudwatchalarm_memory.namespace

    metric_error    = module.cloudwatchalarm_error.metric_name
    namespace_error = module.cloudwatchalarm_error.namespace

    metric_network_tx    = module.cloudwatchalarm_network_tx.metric_name
    namespace_network_tx = module.cloudwatchalarm_network_tx.namespace

    metric_network_rx    = module.cloudwatchalarm_network_rx.metric_name
    namespace_network_rx = module.cloudwatchalarm_network_rx.namespace

}

// CPU ALARM 
module "cloudwatchalarm_cpu" {
    source           = "../cloudwatch-alarm-notify"
    alarm_name       = "${var.service_name}_cpu_utilization"

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
    alarm_name       = "${var.service_name}_memory_utilization"

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
    source = "../cloudwatch-log-metric"

    name             = var.service_name
    filter_pattern   = "Error"
    create_log_group = false
    log_group_name   = var.log_group_name
    metric_name      = "errorfilter"
}

// Error Metric
module "cloudwatchalarm_error" {
    source           = "../cloudwatch-alarm-notify"
    alarm_name       = "${var.service_name}_error_utilization"

    comparison_operator    = "GreaterThanOrEqualToThreshold"
    evaluation_periods     = "1"
    period                 = "300"
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

// Network Meric
module "cloudwatchalarm_network_tx" {
    source           = "../cloudwatch-alarm-notify"
    alarm_name       = "${var.service_name}_network_tx_utilization"

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
    alarm_name       = "${var.service_name}_network_rx_utilization"

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
resource "aws_cloudwatch_dashboard" "all_metric_include" {
  count = var.create_dashboard ? 1 : 0
  dashboard_name = "${var.service_name}-dashboard"

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
          ["ContainerInsights", "pod_cpu_utilization", "ClusterName", "${var.cluster_name}", "Service", "${var.service_name}", "Namespace", "${var.namespace}"]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "${var.service_name} Service CPU Utilization"
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
            ["ContainerInsights", "pod_memory_utilization", "ClusterName", "${var.cluster_name}", "Service", "${var.service_name}", "Namespace", "${var.namespace}"]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "${var.service_name} Service Memory Utilization"
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
            ["LogGroupFilter", "errorfilter"]
        ],
        "period": 300,
        "stat": "Sum",
        "region": "us-east-1",
        "title": "${var.service_name} PodService Error Count"
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
            ["ContainerInsights", "pod_network_tx_bytes", "ClusterName", "${var.cluster_name}", "Service","${var.service_name}", "Namespace","${var.namespace}"]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "${var.service_name} Service Netowrk TX Utilization"
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
            ["ContainerInsights", "pod_network_rx_bytes", "ClusterName", "${var.cluster_name}", "Service","${var.service_name}", "Namespace","${var.namespace}"]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "${var.service_name} Service Netowrk RX Utilization"
        }
    }
  ]
}
EOF
}
