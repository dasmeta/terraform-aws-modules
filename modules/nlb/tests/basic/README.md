# Basic NLB Example

This example validates a generic Network Load Balancer with:

- one TCP listener
- one IP target group
- one `/32` IPv4 allowlist
- target unhealthy alarms with a caller-owned SNS action
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.99 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | ../.. | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | DNS name of the created Network Load Balancer. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the module-managed Network Load Balancer security group. |
| <a name="output_target_unhealthy_alarm_arns"></a> [target\_unhealthy\_alarm\_arns](#output\_target\_unhealthy\_alarm\_arns) | ARNs of unhealthy-target alarms created by the module. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
