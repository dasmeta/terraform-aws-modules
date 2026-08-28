# Tasks: AWS Global Accelerator Wrapper Module

**Input**: Approved design and `specs/003-global-accelerator-module/plan.md`
**Prerequisites**: `spec.md`, `plan.md`, and `docs/superpowers/specs/2026-08-28-global-accelerator-module-design.md`

## Phase 1: Evidence And Detailed Planning

- [x] T001 Create manual Speckit evidence package in `specs/003-global-accelerator-module/`.
- [x] T002 Create the detailed TDD implementation plan in `docs/superpowers/plans/`.
- [x] T003 Independently review and approve the detailed implementation plan.

## Phase 2: Tests First

- [x] T004 Create `tests/contract.tftest.hcl` for defaults, normalization, exact output shapes, IPv4 null behavior, and Dual Stack behavior.
- [x] T005 Create `tests/validation.tftest.hcl` with expected failures for every custom validation family.
- [x] T006 Create the basic and flow-log Terraform fixtures and native fixture runner files.
- [x] T007 Run `terraform init` and `terraform test`, recording the expected RED result caused by the missing wrapper implementation.

## Phase 3: Minimal Wrapper Implementation

- [ ] T008 Add `versions.tf` with Terraform `>= 1.3.0` and AWS provider `~> 5.0`.
- [ ] T009 Add the typed top-level and listener input contract in `variables.tf`.
- [ ] T010 Add all input-only validation rules, including interval and port-override checks.
- [ ] T011 Add `locals.tf` to normalize grouped inputs into the upstream v3 shape.
- [ ] T012 Add `main.tf` with one `terraform-aws-modules/global-accelerator/aws ~> 3.0` module block and no direct resources.
- [ ] T013 Add stable public outputs in `outputs.tf`.
- [ ] T014 Run targeted native tests until the contract and validation suites are GREEN.

## Phase 4: Documentation And Automation

- [ ] T015 Add copy-pasteable README examples and runtime constraint documentation.
- [ ] T016 Generate or reconcile README input/output tables with repository tooling.
- [ ] T017 Add `modules/global-accelerator` to terraform-test, tflint, and checkov matrices.
- [ ] T018 Add the module-specific Terraform 1.7.5 checkout/init/test CI path.

## Phase 5: Verification And Review

- [ ] T019 Run recursive Terraform formatting checks.
- [ ] T020 Initialize and validate the module plus both fixture directories.
- [ ] T021 Run all mocked native Terraform tests and confirm no AWS calls occur.
- [ ] T022 Run relevant tflint and checkov checks when available.
- [ ] T023 Verify the wrapper contains no direct Global Accelerator resources and no customer-specific identifiers.
- [ ] T024 Request independent specification-compliance and code-quality reviews; resolve all blocking findings.
- [ ] T025 Record final command evidence and hand off local testing instructions.

## Dependencies

T001-T003 precede module-impacting edits. T004-T007 precede T008-T013. T014 must pass before documentation and CI are finalized. T019-T025 run after all implementation files are complete.

## Independent Test Criteria

- **US1**: Mocked contract tests verify upstream normalization and stable keyed outputs for existing endpoints.
- **US2**: Negative plan runs prove invalid logical keys, ports, overlaps, overrides, health checks, and weights are rejected.
- **US3**: Flow logs remain disabled by default and require an existing S3 bucket and prefix when enabled.
