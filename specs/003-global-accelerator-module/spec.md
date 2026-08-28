# Feature Specification: AWS Global Accelerator Wrapper Module

**Feature Branch**: `DMVP-10477`
**Created**: 2026-08-28
**Status**: Approved for implementation
**Input**: Create a reusable Standard AWS Global Accelerator Terraform module that wraps an existing upstream module, creates only the accelerator, listeners, and endpoint groups, accepts existing ALB/NLB/EC2/Elastic IP endpoint identifiers, and keeps flow logs disabled by default.

## Operational Scope & Boundaries

**In Scope**: A typed wrapper at `modules/global-accelerator` around `terraform-aws-modules/global-accelerator/aws`; Standard Accelerator creation; TCP/UDP listeners; regional endpoint groups; existing ALB, NLB, EC2, and Elastic IP endpoints; endpoint weights; client IP preservation; traffic dials; health checks; port overrides; IPv4 and Dual Stack; optional flow logs to an existing S3 bucket; stable outputs; executable mock tests; examples; README; and repository CI matrix integration.

**Out of Scope**: Endpoint resource creation, S3 bucket or bucket-policy creation, Custom Routing Accelerators, BYOIP, cross-account attachments, upstream create flags, resource timeouts, DNS record creation, and direct `aws_globalaccelerator_*` resource declarations.

**Impacted Functions**: Platform engineers and service owners that need a reusable global entry point in front of existing regional AWS endpoints.

**Accountable Owner**: DasMeta infrastructure module maintainer.

**Required Approvers**: DasMeta infrastructure module reviewer.

**Downstream Consumers**: Terraform roots that consume modules from this repository.

## User Scenarios & Testing

### User Story 1 - Create A Standard Accelerator For Existing Endpoints (Priority: P1)

As a platform engineer, I need to configure a Standard Accelerator with typed listeners and regional endpoint groups so I can route global traffic to existing AWS endpoints without declaring raw Global Accelerator resources.

**Independent Test**: A native Terraform test plans the wrapper with a mocked AWS provider, verifies the normalized upstream listener and endpoint-group structures, and creates no real infrastructure.

**Acceptance Scenarios**:

1. **Given** a valid accelerator name, TCP or UDP listener, regional endpoint group, and existing endpoint identifier, **When** Terraform plans the module, **Then** the upstream module receives the normalized Standard Accelerator configuration.
2. **Given** multiple listener and endpoint-group map keys, **When** outputs are evaluated, **Then** listener and endpoint-group ARNs retain those logical keys.
3. **Given** IPv4 configuration, **When** outputs are evaluated, **Then** `dual_stack_dns_name` is `null`.
4. **Given** Dual Stack configuration, **When** outputs are evaluated, **Then** the Dual Stack DNS name and IPv4/IPv6 IP sets are exposed.

### User Story 2 - Configure Safe Traffic And Health Behavior (Priority: P1)

As a module consumer, I need invalid ports, ranges, overrides, weights, health checks, and logical keys rejected during planning so AWS runtime failures are limited to conditions that require real resource state.

**Independent Test**: Native negative tests use `expect_failures` for each custom validation family.

**Acceptance Scenarios**:

1. **Given** invalid protocols, ports, overlapping ranges, duplicate regions, or invalid weights, **When** Terraform plans, **Then** `var.listeners` validation fails with an actionable message.
2. **Given** an override whose listener port is not owned by its parent listener, whose endpoint port overlaps any accelerator listener range, or whose mapping conflicts with another override, **When** Terraform plans, **Then** validation fails before an AWS API call.
3. **Given** an invalid HTTP health-check path or a path configured for TCP, **When** Terraform plans, **Then** validation fails.
4. **Given** empty or colon-containing listener or endpoint-group keys, **When** Terraform plans, **Then** validation prevents upstream composite-key collisions.

### User Story 3 - Enable Flow Logs Explicitly (Priority: P2)

As an operator, I need flow logs disabled by default and optionally deliverable to an existing S3 bucket so logging is opt-in and storage permissions remain caller-owned.

**Independent Test**: A mocked plan verifies the default disabled configuration and a flow-log fixture verifies explicit bucket and prefix configuration.

**Acceptance Scenarios**:

1. **Given** `flow_logs` is omitted, **When** Terraform plans, **Then** flow logs are disabled.
2. **Given** flow logs are enabled with non-empty bucket and prefix values, **When** Terraform plans, **Then** the values are forwarded to the upstream module.
3. **Given** flow logs are enabled without a bucket or prefix, **When** Terraform plans, **Then** validation fails.

## Functional Requirements

- **FR-001**: The module MUST live at `modules/global-accelerator`.
- **FR-002**: The module MUST wrap `terraform-aws-modules/global-accelerator/aws` with version `~> 3.0`.
- **FR-003**: The module MUST NOT declare direct Global Accelerator resources.
- **FR-004**: The module MUST create a Standard Accelerator whenever instantiated and expose `enabled` to control traffic acceptance.
- **FR-005**: The module MUST constrain `hashicorp/aws` to `~> 5.0`; upstream dependency resolution therefore requires AWS provider `>= 5.84, < 6.0`.
- **FR-006**: The module MUST support `IPV4` and `DUAL_STACK`, defaulting to `IPV4`.
- **FR-007**: The module MUST accept a typed map of TCP or UDP listeners with one through ten non-overlapping port ranges.
- **FR-008**: Listener and endpoint-group map keys MUST use a non-empty, colon-free logical-key grammar.
- **FR-009**: Every listener MUST include at least one endpoint group, and a listener MUST NOT repeat an endpoint-group Region.
- **FR-010**: Every endpoint group MUST include one through ten existing endpoint identifiers.
- **FR-011**: Endpoint identifiers MUST support existing ALB/NLB ARNs, EC2 instance IDs, and Elastic IP allocation IDs without creating those resources.
- **FR-012**: Endpoint weights MUST default to 128 and accept integer values from 0 through 255.
- **FR-013**: Traffic dial percentage MUST default to 100 and accept values from 0 through 100.
- **FR-014**: Health checks MUST default to TCP, 30-second interval, and threshold 3 while supporting valid TCP/HTTP/HTTPS options.
- **FR-015**: HTTP/S health paths MUST match the AWS path grammar and contain at most 255 characters.
- **FR-016**: Port overrides MUST validate parent-listener membership, endpoint-port non-overlap with every listener range, and mapping uniqueness.
- **FR-017**: Flow logs MUST default to disabled and MUST require non-empty existing S3 bucket and prefix values when enabled.
- **FR-018**: The module MUST expose accelerator ARN, DNS names, hosted-zone ID, typed IP sets, listener ARNs, and nested endpoint-group ARNs.
- **FR-019**: IPv4-only `dual_stack_dns_name` MUST be normalized to `null`.
- **FR-020**: Tests MUST use Terraform mock-provider functionality and MUST NOT contact AWS or provision infrastructure.
- **FR-021**: README examples and executable fixtures MUST match the live interface.
- **FR-022**: The module MUST be added to Terraform test, tflint, and checkov workflow matrices.

## Key Entities

- **Accelerator Configuration**: Name, enabled state, IP address type, flow logs, and tags.
- **Listener**: Logical key, TCP/UDP protocol, client affinity, non-overlapping port ranges, and endpoint groups.
- **Endpoint Group**: Logical key, AWS Region, traffic dial, health check, endpoints, and port overrides.
- **Endpoint**: Existing supported AWS resource identifier, weight, and optional client IP preservation setting.
- **Port Override**: Mapping from a listener-owned port to an endpoint port that does not collide with accelerator listener ranges.
- **Flow Logs**: Explicit opt-in delivery configuration for an existing S3 bucket and prefix.

## Success Criteria

- **SC-001**: `terraform fmt -check -recursive modules/global-accelerator` succeeds.
- **SC-002**: `terraform -chdir=modules/global-accelerator init -backend=false` succeeds.
- **SC-003**: `terraform -chdir=modules/global-accelerator validate` succeeds.
- **SC-004**: `terraform -chdir=modules/global-accelerator test` succeeds using Terraform 1.7 or newer and a mocked AWS provider.
- **SC-005**: Basic and flow-log fixtures initialize and validate without real AWS calls.
- **SC-006**: No direct `resource "aws_globalaccelerator_..."` block exists in the wrapper.
- **SC-007**: Repository CI matrices include `modules/global-accelerator`.
- **SC-008**: Documentation contains no customer-specific identifiers and accurately describes runtime-only AWS constraints.

## Assumptions

- Consumers provide supported endpoints that already exist and are active in the configured endpoint-group Region.
- Consumers own endpoint networking, Dual Stack compatibility, client IP preservation prerequisites, and S3 flow-log bucket permissions.
- Terraform optional object attributes are supported because the module requires Terraform `>= 1.3.0`.
- Terraform `1.7.5` is acceptable for the module-specific mock-test CI path without changing the consumer minimum.

## Risks & Exceptions

- **Risk**: The upstream module accepts `listeners = any` and could change its internal shape in a future major release.
  **Mitigation**: Pin upstream to `~> 3.0`, normalize a typed local interface, and expose stable wrapper outputs.

- **Risk**: AWS/provider runtime checks still govern endpoint existence, Region compatibility, endpoint capabilities, and S3 permissions.
  **Mitigation**: Validate all input-only conditions locally and document the remaining runtime constraints.

- **Risk**: The repository's reusable Terraform test action does not initialize a clean checkout before `terraform test`.
  **Mitigation**: Use a dedicated conditional CI path for this module that performs checkout, Terraform 1.7.5 setup, init, and test.

- **Exception**: The repository lacks `.specify/`. This manual package under `specs/003-global-accelerator-module` is the approved bounded evidence path, following the existing `specs/001-nlb-module` precedent. A strict gate requiring `.specify/feature.json` needs a separate repository bootstrap.
