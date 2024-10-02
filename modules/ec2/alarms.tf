data "aws_instances" "this" {
  filter {
    name   = "tag:Name"
    values = [var.name] # Replace with your instance name
  }
}

module "cw_alerts" {
  count = var.alarms.enabled ? 1 : 0

  source  = "dasmeta/monitoring/aws//modules/alerts"
  version = "1.19.1"

  sns_topic = var.alarms.sns_topic

  alerts = [
    {
      name   = "EC2: High CPU Utilization Alert on Instance ${var.name}"
      source = "AWS/EC2/CPUUtilization"
      filters = {
        InstanceId = data.aws_instances.this.ids[0]
      }
      statistic = try(var.alarms.custom_values.cpu.statistic, "avg")
      threshold = try(var.alarms.custom_values.cpu.threshold, "80") # percent
      period    = try(var.alarms.custom_values.cpu.period, "300")
    },
  ]
}
