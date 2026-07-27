# Feature Specification: Generic AWS NLB Module

**Feature Branch**: `main`
**Created**: 2026-07-27
**Status**: Draft
**Input**: Create a reusable Terraform module under `modules/nlb` that creates an AWS Network Load Balancer, supports security group allowlisting, supports generic target attachment, and adds alerts when targets have health problems.

## Operational Scope & Boundaries

**In Scope**: A reusable AWS Network Load Balancer module in `modules/nlb`, including listener and target group creation, optional target attachment, creation-time security group association with CIDR allowlists, useful outputs, README/example coverage, and CloudWatch target-health alarms.

**Out of Scope**: Environment-specific database wiring, staging-specific names, generated downstream Terraform consumer changes, DNS records, TLS certificate provisioning, and notification endpoint creation.

**Impacted Functions**: Platform engineers and service operators that need reusable TCP/TLS/UDP load balancing.

**Accountable Owner**: DasMeta infrastructure module maintainer.

**Required Approvers**: DasMeta infrastructure module reviewer.

**Downstream Consumers**: Terraform roots that currently consume `dasmeta/modules/aws//modules/...`.

## User Scenarios & Testing

### User Story 1 - Create A Reusable NLB (Priority: P1)

As a platform engineer, I need a reusable module that creates a Network Load Balancer with listeners and target groups so service roots can expose TCP-style targets without writing raw AWS load balancer resources each time.

**Independent Test**: `terraform validate` succeeds for `modules/nlb/tests/basic`.

**Acceptance Scenarios**:

1. **Given** a module consumer provides a name, VPC, subnets, listener, and target group, **When** Terraform is validated, **Then** the module exposes a valid NLB configuration.
2. **Given** a target group defines target attachments, **When** Terraform is validated, **Then** those targets are connected to the matching target group.

### User Story 2 - Restrict NLB Access By CIDR (Priority: P1)

As a platform engineer, I need the module to create or attach security groups at NLB creation time so consumers can allow traffic only from explicit CIDR ranges such as a single `/32`.

**Independent Test**: The basic test includes an explicit `/32` allowlist and validates module inputs.

**Acceptance Scenarios**:

1. **Given** a consumer provides allowed CIDR blocks, **When** Terraform is validated, **Then** the module creates listener-port security group ingress rules for those CIDRs.
2. **Given** a consumer does not want the module-managed security group, **When** they pass existing security group IDs or disable creation, **Then** the module supports that explicit choice.

### User Story 3 - Alert On Target Health Problems (Priority: P2)

As a service operator, I need target-health alarms for each target group so target failures are visible through existing CloudWatch alarm actions.

**Independent Test**: The basic test enables alarms and passes an SNS action ARN.

**Acceptance Scenarios**:

1. **Given** alarms are enabled, **When** Terraform is validated, **Then** the module defines one target-health alarm per target group.
2. **Given** a target group reports unhealthy targets, **When** CloudWatch evaluates the alarm, **Then** configured alarm actions receive the alert.

## Requirements

- **FR-001**: The module MUST live at `modules/nlb`.
- **FR-002**: The module MUST create an AWS Network Load Balancer through an opinionated wrapper interface.
- **FR-003**: The module MUST support internal and internet-facing NLBs.
- **FR-004**: The module MUST support listener definitions for TCP, TLS, UDP, and TCP_UDP.
- **FR-005**: The module MUST support target groups with IP, instance, or ALB targets.
- **FR-006**: The module MUST support target attachments keyed by target group.
- **FR-007**: The module MUST support module-managed security group creation with IPv4 CIDR allowlists.
- **FR-008**: The module MUST support existing security group IDs when consumers manage security groups externally.
- **FR-009**: The module MUST document that NLB security groups should be associated at creation time when allowlisting is required.
- **FR-010**: The module MUST create CloudWatch target-health alarms per target group when alarms are enabled.
- **FR-011**: Alarm actions MUST be supplied by consumers; the module MUST NOT create notification endpoints.
- **FR-012**: The module MUST expose load balancer, listener, target group, security group, and alarm outputs useful to downstream roots.
- **FR-013**: The module MUST include at least one executable Terraform example test.
- **FR-014**: The module MUST be added to repository workflow matrices that enumerate module paths.

## Key Entities

- **NLB Module Configuration**: Module-level name, VPC, subnets, scheme, tags, security group behavior, listeners, target groups, and alarms.
- **Listener**: Port/protocol entry that forwards to a target group.
- **Target Group**: Backend routing and health-check configuration.
- **Target Attachment**: Target ID plus optional target port and availability zone.
- **Target Health Alarm**: CloudWatch alarm watching `AWS/NetworkELB` target health dimensions.

## Success Criteria

- **SC-001**: `terraform validate` succeeds for `modules/nlb`.
- **SC-002**: `terraform validate` succeeds for `modules/nlb/tests/basic`.
- **SC-003**: The module exposes a generic interface with no environment-specific or staging-specific naming.
- **SC-004**: The README documents the one-IP allowlist use case and target-health alarm behavior.

## Assumptions

- Consumers can provide SNS topic ARNs or other CloudWatch alarm action ARNs.
- A wrapper around `terraform-aws-modules/alb/aws` is acceptable because that upstream module supports Network Load Balancer resources.
- Terraform optional object attributes are acceptable in this repository for new module code.

## Risks & Exceptions

- **Risk**: An NLB created without security groups cannot have security groups added later without replacement.
  **Mitigation**: Document this constraint and make security group behavior explicit.

- **Risk**: Broad pass-through inputs would make the wrapper hard to support.
  **Mitigation**: Expose only common NLB inputs and rely on the upstream module for low-level implementation details.

- **Exception**: The repository currently lacks `.specify/`; this package records the module-change evidence manually under `specs/001-nlb-module`.
