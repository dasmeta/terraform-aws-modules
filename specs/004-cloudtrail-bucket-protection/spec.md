# Feature Specification: CloudTrail bucket protection

**Feature Branch**: `004-cloudtrail-bucket-protection`
**Created**: 2026-10-20
**Status**: Confirmed for implementation by operator
**Input**: Complete DS-13726 / Sela MR !183 by implementing bucket versioning, five-year Governance Object Lock and force_destroy=false. Preserve the existing bucket, CloudTrail destination and validation. Emergency bypass is limited to a dedicated role trusted by SSO admins with a human approval process. No infrastructure apply is authorized.

## User Scenarios & Testing

### User Story 1 - Protect an existing audit bucket (Priority: P1)
Operators enable versioning and five years of Governance retention, disable forced destruction, and restrict bypass to approved emergency roles.
**Independent Test**: Mocked Terraform plans check the protection resources and policy; existing-state production plan remains a separate deployment gate.
**Acceptance Scenarios**:
1. Protected configuration declares enabled versioning, GOVERNANCE retention for five years, force_destroy=false, and only approved role exceptions to a bypass deny.
2. Existing bucket/trail resource addresses and service delivery statements remain stable; bucket-level object_lock_enabled is not configured because that attribute triggers replacement in provider 5.x.
3. Default consumers preserve their existing behavior; externally owned buckets are not taken over.

### User Story 2 - Expose controls through the account wrapper (Priority: P1)
Consumers configure the same narrow bucket-protection object under cloudtrail, without broad upstream passthrough or changing existing defaults.
**Independent Test**: Verify the wrapper forwards all four protection fields to the tested child module and consumer-generated Terraform reflects the object.

### Edge Cases
- Lock enablement is irreversible and default retention is not retroactive for existing versions.
- Removing Terraform lock configuration removes the default retention rule; it does not disable Object Lock. Never present that removal as a safe rollback.
- Versioning propagation and continued CloudTrail ingestion require live validation. No mock can prove existing-state non-replacement or real IAM enforcement.
- Empty emergency allowlist produces an unconditional bypass deny; never emit an empty IAM condition array.
- Require versioning and force_destroy=false when Governance years are nonzero. Reject invalid years and wildcard/non-role exception ARNs.
- An SSO admin may assume the dedicated emergency role only under the operational approval process; IAM does not enforce approval itself. Bucket policy admins remain privileged and must follow change control.

## Requirements
- **FR-001**: Add opt-in protection controls while preserving all old defaults and existing resource addresses.
- **FR-002**: Use standalone versioning/Object Lock configuration resources to modify the existing bucket without setting the replacement-sensitive bucket argument.
- **FR-003**: Preserve CloudTrail/Config delivery permissions and add explicit bypass-deny enforcement for all other principals.
- **FR-004**: Pass controls through the account module and wire the Sela YAML/generated Terraform to immutable dependency revisions for review, pending supported releases.
- **FR-005**: Add meaningful mocked native tests, independently expressed examples, and usage documentation.
- **FR-006**: Keep no new Markdown in Sela MR !183; shared-module Speckit evidence belongs to its respective downstream PRs.
- **FR-007**: Do not apply cloud infrastructure, publish releases or merge shared PRs during this request.

## Success Criteria
- Both shared modules validate with the Sela AWS 5.x provider context and native mocked tests pass without AWS credentials.
- Defaults preserve the old resource set; protection enables exactly the expected versioning/retention/force-destruction/policy behavior.
- Sela source and regenerated Terraform explicitly request all three missing controls; reviewable dependency PRs are linked.
- Existing-state zero-replacement planning, historical-version protection and deployment approval remain explicit gates.

## Assumptions
- Existing child module already uses Terraform1.3 optional attributes in cmdb_integration/alerts, and its basic verification setup requires >=1.3. Use the same optional grouped-field convention without raising the effective runtime floor.
- Account wrapper already requires Terraform ~>1.3 and can expose optional grouped attributes safely.
- Use five calendar years for S3 Governance; the existing 1827-day CloudWatch work is unchanged.
