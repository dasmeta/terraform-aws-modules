# Tasks: Generic AWS NLB Module

**Input**: Design documents from `specs/001-nlb-module/`
**Prerequisites**: `spec.md`, `plan.md`, `research.md`, `data-model.md`, `contracts/module-interface.md`

## Phase 1: Setup

- [x] T001 Create manual Speckit evidence package in `specs/001-nlb-module/`
- [x] T002 Create `modules/nlb/tests/basic` Terraform example test before production module code

## Phase 2: User Story 1 - Create A Reusable NLB

- [x] T003 [US1] Run red `terraform -chdir=modules/nlb/tests/basic init -backend=false` and `terraform -chdir=modules/nlb/tests/basic validate`
- [x] T004 [US1] Implement NLB wrapper resources in `modules/nlb/main.tf`
- [x] T005 [US1] Implement module input contract in `modules/nlb/variables.tf`
- [x] T006 [US1] Implement module outputs in `modules/nlb/outputs.tf`
- [x] T007 [US1] Implement provider constraints in `modules/nlb/versions.tf`

## Phase 3: User Story 2 - Restrict NLB Access By CIDR

- [x] T008 [US2] Add listener-port security group ingress rule derivation in `modules/nlb/main.tf`
- [x] T009 [US2] Document NLB security group creation-time behavior in `modules/nlb/README.md`

## Phase 4: User Story 3 - Alert On Target Health Problems

- [x] T010 [US3] Add per-target-group `AWS/NetworkELB` unhealthy-target alarms in `modules/nlb/main.tf`
- [x] T011 [US3] Add alarm outputs in `modules/nlb/outputs.tf`
- [x] T012 [US3] Document alarm inputs and behavior in `modules/nlb/README.md`

## Phase 5: CI And Verification

- [x] T013 Add `modules/nlb` to workflow matrices in `.github/workflows/`
- [x] T014 Run `terraform fmt -check modules/nlb`
- [x] T015 Run `terraform -chdir=modules/nlb init -backend=false`
- [x] T016 Run `terraform -chdir=modules/nlb validate`
- [x] T017 Run `terraform -chdir=modules/nlb/tests/basic init -backend=false`
- [x] T018 Run `terraform -chdir=modules/nlb/tests/basic validate`

## Dependencies

T001 before all implementation. T002 and T003 before production module code. T004-T008 before T010-T012. Verification runs after implementation and docs.

## Independent Test Criteria

- **US1**: Basic example validates with one listener and one target group.
- **US2**: Basic example validates with a single `/32` CIDR allowlist.
- **US3**: Basic example validates with target-health alarms enabled and alarm actions supplied.
