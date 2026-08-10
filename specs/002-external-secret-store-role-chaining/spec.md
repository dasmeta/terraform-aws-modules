# Feature Specification: External Secret Store via IAM Role Chaining

**Feature Branch**: `external-secret-improvements`
**Created**: 2026-08-03
**Status**: Implemented
**Input**: Replace the `external-secret-store` module's IAM user and static access keys with a
per-store IAM role that the External Secrets controller assumes, and render the
SecretStore/ClusterSecretStore to use that role instead of a credentials secretRef.

## Operational Scope & Boundaries

**In Scope**: The `modules/external-secret-store` module - its IAM role and least-privilege
policy, the rendered SecretStore/ClusterSecretStore, its input surface, outputs, and README.

**Out of Scope**: The External Secrets controller itself and its Pod Identity association, which
live in the dasmeta EKS module and are specified there; consumer Terraform roots; secret values;
and the Secrets Manager entries the stores read.

**Impacted Functions**: Platform engineers operating EKS clusters that sync secrets from AWS
Secrets Manager.

**Accountable Owner**: DasMeta infrastructure module maintainer.

**Required Approvers**: DasMeta infrastructure module reviewer.

**Downstream Consumers**: Terraform roots calling
`dasmeta/modules/aws//modules/external-secret-store`, paired with the dasmeta EKS module.

## Context

The module created an IAM user per store, generated an access key, wrote it into a Kubernetes
Secret, and pointed the store's `spec.provider.aws.auth.secretRef` at it. That places long-lived
static credentials in cluster Secrets and in Terraform state, once per store, with no rotation.

The controller now runs with its own AWS identity and is permitted to assume roles matching a
name prefix. This module therefore creates a role per store instead of a user, and the store
authenticates by assuming it.

## User Scenarios & Testing

### User Story 1 - No Static Credentials Per Store (Priority: P1)

As a platform engineer, creating a secret store does not create an IAM user or an access key.

**Why this priority**: Eliminating long-lived static credentials is the purpose of the change.

**Independent Test**: Apply the module and confirm the store syncs while no IAM user, access key
or credentials Secret exists for it.

**Acceptance Scenarios**:

1. **Given** the module is applied, **When** its resources are inspected, **Then** it has created
   an IAM role and policy and no IAM user, access key, or Kubernetes Secret.
2. **Given** the rendered store, **When** its spec is read, **Then** it authenticates through
   `spec.provider.aws.role` and contains no `secretRef`.

### User Story 2 - Least Privilege Per Store (Priority: P1)

As a security reviewer, each store can read only the secrets belonging to it.

**Why this priority**: The controller can assume every store role, so the blast radius of any
one store is bounded solely by that role's own policy.

**Independent Test**: Inspect the role policy and confirm the resource scope is limited to the
store's own secret name prefix.

**Acceptance Scenarios**:

1. **Given** a store named `app/prod`, **When** its policy is read, **Then** read access is
   scoped to Secrets Manager secrets whose name starts with `app/prod`.
2. **Given** the role's trust policy, **When** it is read, **Then** only the controller's base
   role may assume it.

### User Story 3 - Assumable by the Controller (Priority: P1)

As an operator, the controller can actually assume the store role.

**Why this priority**: The controller's permission is a name-prefix wildcard. If the store's role
name does not carry that prefix, the store silently fails to sync.

**Independent Test**: Apply with the prefix matching the controller's, and confirm the store
reaches ready.

**Acceptance Scenarios**:

1. **Given** the configured role name prefix, **When** the role is created, **Then** its name
   begins with that prefix.
2. **Given** a prefix that differs from the controller's, **When** the store is used, **Then**
   the assume-role call is denied - the two sides must agree.

### Edge Cases

- Store names may contain `/`, which IAM role names disallow, so names must be sanitised.
- IAM is global, so multi-region setups need a uniqueness prefix to avoid role-name collisions.
- `ClusterSecretStore` is cluster-scoped and must not carry a namespace.
- Consumers upgrading from the previous version have their IAM user, access key and credentials
  Secret destroyed; that is intended, but it means the controller must already have its identity
  before this module is upgraded.

## Requirements

### Functional Requirements

- **FR-001**: The module MUST create a per-store IAM role and MUST NOT create an IAM user,
  access key, or credentials Kubernetes Secret.
- **FR-002**: The role's trust policy MUST permit only the supplied controller role to assume it.
- **FR-003**: The role's permissions MUST be read-only Secrets Manager access scoped to secrets
  whose name starts with the store name.
- **FR-004**: The role name MUST begin with the configured prefix so the controller's grant
  covers it, and MUST support an additional uniqueness prefix for multi-region setups.
- **FR-005**: The rendered store MUST set `spec.provider.aws.role` and MUST NOT contain a
  `secretRef`.
- **FR-006**: The module MUST support both `SecretStore` and `ClusterSecretStore`, omitting the
  namespace for the cluster-scoped kind, and MUST reject any other kind.
- **FR-007**: The controller role ARN MUST be a required input, since there is no safe default.
- **FR-008**: The module MUST expose the store role ARN and the resolved store name as outputs.
- **FR-009**: The store resource MUST NOT be recreated on upgrade from the previous version.

### Non-Functional Requirements

- **NFR-001**: Region resolution MUST work across the provider versions the module's constraint
  allows.
- **NFR-002**: Version constraints MUST be pessimistic and explicitly sourced.

## Success Criteria

### Measurable Outcomes

- **SC-001**: After an apply, no IAM user, access key, or credentials Secret exists for any
  store, and every store reports ready.
- **SC-002**: A forced ExternalSecret refetch succeeds, proving live credentials rather than
  previously cached values.
- **SC-003**: Each store role's policy resists reading secrets outside its own name prefix.
- **SC-004**: Terraform formatting, validation and static analysis pass.

## Assumptions

- The controller has an AWS identity and holds `sts:AssumeRole` on the configured role-name
  prefix; that is provided by the dasmeta EKS module.
- Consumers upgrade the EKS module before this one, so the controller identity exists by the
  time stores switch to role-based auth.
- The External Secrets version in use serves `external-secrets.io/v1`.
