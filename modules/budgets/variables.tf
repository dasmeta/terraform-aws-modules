variable "is_enabled" {
  type        = bool
  description = "(Optional) A boolean flag to enable/disable Budgets. Defaults true."
  default     = true
}
variable "aws_budgets_budget" {
  type = object(
    {
      # The name of a budget. Unique within accounts.
      name = string
      # Whether this budget tracks monetary cost or usage.
      budget_type = string
      # Map of Cost Filters key/value pairs to apply to the budget.
      cost_filters = map(any)
      # The amount of cost or usage being measured for a budget.
      limit_amount = string
      # Object containing Budget Notifications. Can be used multiple times to define more than one budget notification
      notification = list(any)
    }
  )
  description = "(Required) Provides a budgets budget resource. Budgets use the cost visualisation provided by Cost Explorer to show you the status of your budgets, to provide forecasts of your estimated costs, and to track your AWS usage, including your free tier usage."
}

variable "aws_cloudwatch_event_rule" {
  type = object(
    {
      # The name of the rule. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix.
      name = string
      # The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes). At least one of schedule_expression or event_pattern is required. Can only be used on the default event bus.
      schedule_expression = string
      # The description of the rule.
      description = string
      # Whether the rule should be enabled (defaults to true).
      is_enabled = bool
    }
  )
  description = "(Optional) Provides an EventBridge Rule resource."
  default = {
    name                = "budgets-cloudwatch-event-rule"
    description         = "This cloudwatch event used for Budgets."
    schedule_expression = "cron(0 9 * * ? *)"
    is_enabled          = true
  }
}
variable "aws_cloudwatch_event_target" {
  type = object(
    {
      # The Amazon Resource Name (ARN) associated of the target.
      arn = string
    }
  )
  description = "(Required) Provides an EventBridge Target resource."
}
variable "tags" {
  type        = map(any)
  description = "(Optional) Key-value map of resource tags."
  default     = null
}
