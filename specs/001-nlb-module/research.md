# Research: Generic AWS NLB Module

## Decision: Wrap `terraform-aws-modules/alb/aws`

**Rationale**: The approved AWS module collection already has a maintained module that creates Network Load Balancers, listeners, target groups, target attachments, and security groups. A DasMeta wrapper can keep the consumer interface smaller and add target-health alarms.

**Alternatives considered**:

- Direct AWS resources: rejected because it would recreate an existing upstream module surface.
- Kubernetes ingress module: rejected because it is ALB ingress-controller-specific and does not create a raw AWS NLB.

## Decision: Require AWS Provider >= 5.99

**Rationale**: The selected upstream module version requires AWS provider >= 5.99, and this remains compatible with consumers using the AWS provider 5.x range.

**Alternatives considered**:

- Older upstream module versions: rejected because current NLB security group support is a core requirement.
- Latest upstream main: rejected because it requires AWS provider 6.x and Terraform >= 1.5.7.

## Decision: Create Target-Health Alarms In The Wrapper

**Rationale**: Target health is part of the requested NLB operational behavior. CloudWatch publishes `AWS/NetworkELB` metrics with `LoadBalancer` and `TargetGroup` dimensions. Creating one alarm per target group keeps behavior predictable.

**Alternatives considered**:

- Use `cloudwatch-alarm-notify`: rejected for this module because notification endpoint creation would broaden the interface.
- Leave alarms to consumers: rejected because the user specifically requested related alerts.

## Decision: Keep Notification Actions Consumer-Owned

**Rationale**: SNS topics, Opsgenie, Slack, and email endpoints are environment-owned. The NLB module should accept CloudWatch action ARNs without owning notification plumbing.

**Alternatives considered**:

- Create SNS topics inside the module: rejected because it would mix load-balancing and notification ownership.
