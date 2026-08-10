# Tasks: External Secret Store via IAM Role Chaining

**Input**: `specs/002-external-secret-store-role-chaining/spec.md`
**Prerequisites**: `spec.md`, `plan.md`

All tasks are marked complete: this package was authored after the implementation, as recorded
in the Process Note in `plan.md`.

## Phase 1: Remove the Static-Credential Path

- [X] T001 [US1] Delete `iam-user.tf`, removing the per-store IAM user and access key.
- [X] T002 [US1] Delete `secret.tf`, removing the Kubernetes Secret that held the access key.
- [X] T003 [US1] Delete `secret-store.tmpl`, whose only purpose was rendering the `secretRef`
  auth block.

## Phase 2: Per-Store Role

- [X] T004 [US1] Add `iam.tf` creating the per-store IAM role.
- [X] T005 [US2] Scope the role's policy to read-only Secrets Manager actions on secrets whose
  name starts with the store name.
- [X] T006 [US3] Restrict the role's trust policy to the supplied controller role only.
- [X] T007 [US3] Name the role with the configured prefix so the controller's wildcard grant
  covers it, keeping the existing per-region uniqueness prefix available.
- [X] T008 [US1] Sanitise store names for IAM, since store names may contain `/` and role names
  may not.

## Phase 3: Store Manifest

- [X] T009 [US1] Rewrite `store.tf` to render with `yamlencode` and authenticate through
  `spec.provider.aws.role`.
- [X] T010 Include `metadata.namespace` only for the namespaced `SecretStore` kind.
- [X] T011 [US3] Order the manifest after the role policy attachment so the role is usable when
  the store appears.
- [X] T012 Keep the manifest's resource address unchanged so upgrades update it in place rather
  than recreating it.

## Phase 4: Interface

- [X] T013 [US3] Add the required `controller_role_arn` input.
- [X] T014 [US3] Add `store_role_name_prefix`, documenting that it must match the controller's.
- [X] T015 Remove `create_user`, `aws_access_key_id`, `aws_access_secret`, `aws_role_arn`, and
  the unused `controller` input.
- [X] T016 Validate `kind` against the two supported values.
- [X] T017 Default `external_secrets_api_version` to `external-secrets.io/v1`.
- [X] T018 Add outputs for the store role ARN, resolved name and kind.
- [X] T019 Rename `providers.tf` to `versions.tf` and add the AWS provider constraint.

## Phase 5: Correctness Fix Found During Review

- [X] T020 Resolve the provider region using an attribute present in every provider version the
  module's constraint allows. The originally used attribute exists only from AWS provider 6.0,
  while the constraint permits 5.x, and consumers pairing this module with the dasmeta EKS
  module resolve to 5.x because that module caps below 6.0 - so the store would have failed on
  every such consumer.

## Phase 6: Documentation

- [X] T021 Rewrite the README to describe the auth model, the controller relationship and the
  prefix-matching requirement.
- [X] T022 Ensure the cross-repository upgrade ordering and validation steps are documented in
  the EKS module's upgrade guide, where consumers of both modules will look.

## Phase 7: Verification

- [X] T023 Run `terraform fmt -check -recursive`.
- [X] T024 Run `terraform validate`.
- [X] T025 Run `tflint`, `tfsec` and `checkov`.
- [X] T026 Confirm the rendered store's name, kind and apiVersion match the consuming chart's
  ExternalSecret reference, and that the secret it reads falls inside the role's scope.
- [X] T027 Apply against a live cluster and confirm secrets sync.

## Follow-Up (Out of Scope)

- [ ] T028 Replace the hardcoded `aws` partition ARN with `data.aws_partition`; no module in the
  repository currently does this, so changing only this one would diverge from convention.
- [ ] T029 Consider validating the composed role name length, since the store name plus both
  prefixes can exceed the IAM 64-character limit for long names.

## Dependencies

- T001-T003 remove the old path; T004-T008 replace it.
- T009-T012 depend on the role existing.
- T013-T019 expose the new contract; T013 is what consumers must supply from the EKS module's
  output, so that module's change is a prerequisite for using this one.
- T020 was found by comparing provider schemas, not by validating this module alone.
- T023-T027 verify the whole change.
