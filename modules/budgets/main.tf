#--------------------------------------------------------------
# Provides a budgets budget resource. Budgets use the cost visualisation provided by Cost Explorer to show you the status of your budgets, to provide forecasts of your estimated costs, and to track your AWS usage, including your free tier usage.
#--------------------------------------------------------------
resource "aws_budgets_budget" "this" {
  count        = var.is_enabled ? 1 : 0
  name         = lookup(var.aws_budgets_budget, "name")
  budget_type  = lookup(var.aws_budgets_budget, "budget_type", "COST")
  cost_filters = lookup(var.aws_budgets_budget, "cost_filters", [])
  dynamic "cost_types" {
    for_each = lookup(var.aws_budgets_budget, "cost_types", [{}])
    content {
      include_credit             = lookup(cost_types.value, "include_credit", true)
      include_discount           = lookup(cost_types.value, "include_discount", true)
      include_other_subscription = lookup(cost_types.value, "include_other_subscription", true)
      include_recurring          = lookup(cost_types.value, "include_recurring", true)
      include_refund             = lookup(cost_types.value, "include_refund", true)
      include_subscription       = lookup(cost_types.value, "include_subscription", true)
      include_support            = lookup(cost_types.value, "include_support", true)
      include_tax                = lookup(cost_types.value, "include_tax", true)
      include_upfront            = lookup(cost_types.value, "include_upfront", true)
      use_amortized              = lookup(cost_types.value, "use_amortized", false)
      use_blended                = lookup(cost_types.value, "use_blended", false)
    }
  }
  limit_amount      = lookup(var.aws_budgets_budget, "limit_amount")
  limit_unit        = lookup(var.aws_budgets_budget, "limit_unit", "USD")
  time_period_end   = lookup(var.aws_budgets_budget, "time_period_end", "2050-12-31_00:00")
  time_period_start = lookup(var.aws_budgets_budget, "time_period_start", "2021-01-01_00:00")
  time_unit         = lookup(var.aws_budgets_budget, "time_unit", "MONTHLY")
  dynamic "notification" {
    for_each = lookup(var.aws_budgets_budget, "notification", [{}])
    content {
      comparison_operator        = lookup(notification.value, "comparison_operator", "GREATER_THAN")
      threshold                  = lookup(notification.value, "threshold", "80")
      threshold_type             = lookup(notification.value, "threshold_type", "PERCENTAGE")
      notification_type          = lookup(notification.value, "notification_type", "ACTUAL")
      subscriber_email_addresses = lookup(notification.value, "subscriber_email_addresses", null)
      subscriber_sns_topic_arns  = lookup(notification.value, "subscriber_sns_topic_arns", null)
    }
  }
}

#--------------------------------------------------------------
# Provides an EventBridge Rule resource.
#--------------------------------------------------------------
resource "aws_cloudwatch_event_rule" "this" {
  count               = var.is_enabled ? 1 : 0
  name                = lookup(var.aws_cloudwatch_event_rule, "name", "budgets-cloudwatch-event-rule")
  schedule_expression = lookup(var.aws_cloudwatch_event_rule, "schedule_expression", "cron(0 9 * * ? *)")
  description         = lookup(var.aws_cloudwatch_event_rule, "description", "This cloudwatch event used for Budgets.")
  is_enabled          = lookup(var.aws_cloudwatch_event_rule, "is_enabled", true)
  tags                = var.tags
}
#--------------------------------------------------------------
# Provides an EventBridge Target resource.
#--------------------------------------------------------------
resource "aws_cloudwatch_event_target" "this" {
  count = var.is_enabled ? 1 : 0
  rule  = aws_cloudwatch_event_rule.this[0].name
  arn   = lookup(var.aws_cloudwatch_event_target, "arn")
  depends_on = [
    aws_cloudwatch_event_rule.this[0]
  ]
}
