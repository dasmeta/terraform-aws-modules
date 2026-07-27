# Data Model: Generic AWS NLB Module

## NLB Configuration

- `name`: Load balancer name.
- `vpc_id`: VPC where target groups and optional security group are created.
- `subnet_ids`: Subnets attached to the NLB.
- `internal`: Whether the NLB is internal.
- `tags`: Tags applied to supported resources.

## Listener

- `port`: Listener port.
- `protocol`: TCP, TLS, UDP, or TCP_UDP.
- `target_group_key`: Key of the target group receiving traffic.
- `certificate_arn`: Required by consumers for TLS listeners.
- `ssl_policy`: Optional TLS policy.

## Target Group

- `port`: Backend target port.
- `protocol`: Backend protocol.
- `target_type`: IP, instance, or alb.
- `health_check`: Optional health-check override.
- `targets`: Map of target attachments.

## Target Attachment

- `target_id`: Target IP, instance ID, or ALB ARN depending on target type.
- `port`: Optional override target port.
- `availability_zone`: Optional target availability zone.

## Security Group Configuration

- `create`: Whether to create a module-managed NLB security group.
- `allowed_cidr_blocks`: IPv4 CIDR allowlist.
- `allowed_ipv6_cidr_blocks`: IPv6 CIDR allowlist.
- `security_group_ids`: Existing security groups to attach.
- `egress_cidr_blocks`: IPv4 outbound CIDRs.
- `egress_ipv6_cidr_blocks`: IPv6 outbound CIDRs.

## Alarm Configuration

- `enabled`: Whether target-health alarms are created.
- `alarm_actions`: CloudWatch action ARNs to invoke on alarm.
- `ok_actions`: CloudWatch action ARNs to invoke on recovery.
- `threshold`: Unhealthy target threshold.
- `period`: Alarm period.
- `evaluation_periods`: Alarm evaluation periods.
- `datapoints_to_alarm`: Optional datapoints to alarm.
- `treat_missing_data`: Missing-data behavior.
