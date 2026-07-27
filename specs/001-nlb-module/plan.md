# Implementation Plan: Generic AWS NLB Module

**Branch**: `main` | **Date**: 2026-07-27 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `specs/001-nlb-module/spec.md`

## Summary

Add `modules/nlb` as a generic, reusable AWS Network Load Balancer wrapper. The module will use `terraform-aws-modules/alb/aws` as the baseline for NLB/listener/target-group/security-group resources and add DasMeta-specific target-health CloudWatch alarms.

## Technical Context

**Language/Version**: Terraform >= 1.3.0
**Primary Dependencies**: AWS provider >= 5.99, `terraform-aws-modules/alb/aws` ~> 9.17
**Storage**: N/A
**Testing**: `terraform fmt -check`, `terraform init -backend=false`, `terraform validate`
**Target Platform**: AWS Network Load Balancer
**Project Type**: Terraform module repository
**Performance Goals**: No runtime code; generated AWS resources must remain limited to common NLB paths.
**Constraints**: Generic module only; no staging or database-specific content; security groups must be created/attached at NLB creation time when used.
**Scale/Scope**: One new module, one example test, workflow matrix additions.

## Constitution Check

- **Scope Gate**: PASS. Scope is limited to `modules/nlb`, its test, docs, and CI path listings.
- **Ownership Gate**: PASS. Module ownership remains in this repository.
- **Records Gate**: PASS WITH EXCEPTION. Repo lacks `.specify/`; local `specs/001-nlb-module` is the manually recorded evidence package.
- **Controls Gate**: PASS. Terraform formatting and validation are defined.
- **Change Gate**: PASS. This is additive and does not change existing module behavior.

## Project Structure

```text
modules/nlb/
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── README.md
└── tests/
    └── basic/
        ├── 0-setup.tf
        ├── 1-example.tf
        ├── 2-assert.tf
        └── README.md
```

## Pre-Change Plan

### Current Repository Module State

The repository contains many first-party modules under `modules/`. Closest related modules are `ingress` for Kubernetes ALB ingress annotations and `cloudwatch-alarm-notify` / `service-alerts` for alert patterns. There is no raw AWS NLB module.

### Gaps Versus Internal Standards

The target module does not exist yet. New files must include documented variables, outputs, examples/tests, version constraints, and generated or consistent README content.

### Wrapper-Preservation Assessment

The module will be an opinionated wrapper, not a broad pass-through. It exposes grouped objects for listeners, target groups, targets, and alarms. It intentionally does not expose DNS, certificate creation, notification endpoint creation, or every upstream ALB module input.

### Provider Collection Checked

Checked approved AWS module collection: `terraform-aws-modules`.

### Candidate Upstream Modules Considered

- `terraform-aws-modules/alb/aws`: supports Application and Network Load Balancers, listeners, target groups, target attachments, and security groups.
- Direct AWS resources: rejected because a suitable upstream module exists.

### Chosen Wrapper Baseline

Use `terraform-aws-modules/alb/aws` with `load_balancer_type = "network"` and a narrower DasMeta interface. The wrapper adds CIDR allowlist defaults and target-health CloudWatch alarms.

### Constitution Repository Source Used

Used `/Users/Adeline/.codex/constitution/skills/terraform-module-developer/references/internal-module-standards.md` and planning checklist.

### Speckit Evidence

Manual evidence package: `specs/001-nlb-module/` with `spec.md`, `plan.md`, and `tasks.md`. Repo lacks `.specify/`, so this is recorded as a bounded workflow gap.

### Module-Change Gate Compatibility

Expected to satisfy a review-visible Speckit evidence requirement by including the local package. If a strict gate requires `.specify/feature.json`, this repo needs a separate Spec Kit bootstrap.

### Fallback Rationale

No fallback direct-resource scaffolding is needed because `terraform-aws-modules/alb/aws` is suitable.

### Proposed File Changes

- Add `modules/nlb/main.tf`.
- Add `modules/nlb/variables.tf`.
- Add `modules/nlb/outputs.tf`.
- Add `modules/nlb/versions.tf`.
- Add `modules/nlb/README.md`.
- Add `modules/nlb/tests/basic/*`.
- Add `modules/nlb` to workflow matrices that enumerate module paths.
- Add `specs/001-nlb-module/*` evidence files.

### Potential Breaking Changes

None. The module is additive.

### Potential Interface-Widening Changes

None requiring approval. The interface is intentionally narrower than the upstream module.

### Conflicts Requiring Approval

No standards conflict found. The only workflow gap is missing `.specify/` bootstrap in the repository.

## Modern Capabilities Check

- **NLB creation**: supported by AWS provider and upstream module.
- **NLB security groups**: supported. AWS documents creation-time association constraints for NLB security groups.
- **Target health alarms**: supported through CloudWatch `AWS/NetworkELB` metrics.

## Phase 0 Research

See [research.md](research.md).

## Phase 1 Design

See [data-model.md](data-model.md), [contracts/module-interface.md](contracts/module-interface.md), and [quickstart.md](quickstart.md).

## Post-Design Constitution Check

- **Scope Gate**: PASS.
- **Ownership Gate**: PASS.
- **Records Gate**: PASS WITH EXCEPTION for missing `.specify/`.
- **Controls Gate**: PASS.
- **Change Gate**: PASS.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Manual Speckit package | Repo lacks `.specify/` | Editing module files with no evidence would violate the module workflow |
