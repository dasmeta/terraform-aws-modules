# Tasks: CloudTrail bucket protection

## Setup and foundation
- [x] T001 Read current source, operator scope, provider evidence and CloudBrowser record275; preserve unrelated work using this isolated checkout.
- [x] T002 Execute specification/planning, record default compatibility and provider/resource-identity constraints in spec.md, plan.md and research.md.

## User Story 1: CloudTrail protection
- [x] T003 [US1] Add bounded protection input and validation in modules/cloudtrail/variables.tf.
- [x] T004 [US1] Parameterize force_destroy, add standalone configuration and bypass-deny policy in modules/cloudtrail/s3.tf; order new trail creation in modules/cloudtrail/cloudtrail.tf.
- [x] T005 [US1] Add independent example under modules/cloudtrail/examples/bucket-protection/ and meaningful native mocked tests in modules/cloudtrail/tests/bucket_protection.tftest.hcl; update module README.md.
- [x] T006 [US1] Initialize, validate and run native mocked tests in modules/cloudtrail; verify no bucket-level replacement-sensitive argument is introduced.

## Delivery
- [x] T007 Request read-only review, fix significant findings, publish a draft dependency PR and record exact commit/test evidence in validation.md.
- [x] T008 Wire the shared revision through account/Sela and regenerate consumer Terraform without new Sela Markdown; no merge, release or cloud apply.

## Dependencies and strategy
T001→T002→T003→T004→T005→T006→T007→T008. Research can run independently; file mutations are sequential. Defaults are the compatibility baseline; protected and negative cases independently verify the feature. Deployment is outside scope and requires an existing-state plan and exact approval.

## Calendar-duration review correction
- [x] R001 Add optional day retention and mutually exclusive unit validation; preserve existing year-based consumers.
- [x] R002 Update examples, native mocked tests and account resource-state verification for 1827 days.
- [ ] R003 Validate, publish dependency revisions, regenerate Sela Terraform and update evidence.
