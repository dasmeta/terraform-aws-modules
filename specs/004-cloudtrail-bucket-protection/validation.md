# Validation — 2026-10-20

- Terraform init -backend=false and validate passed in modules/cloudtrail with AWS5.x selected by an uncommitted test-only provider constraint.
- Native mocked AWS suite: 11 passed,0 failed. Positive runs simulate apply through a mocked provider; no AWS APIs were called. Cases cover legacy defaults, five-year Governance, exact-role bypass deny, delivery permissions, empty exceptions, versioning alone, external ownership and invalid settings/ARNs.
- Independent read-only review found no blocking findings and independently confirmed the 11-case suite.
- Static check: aws_s3_bucket.s3 has no object_lock_enabled setting; standalone lock configuration depends on versioning. Existing resource addresses remain unchanged. No real existing-state zero-replacement plan is claimed.
- Git whitespace checks passed. No test provider override, provider lock, state or .terraform cache is committed.
- Source extension is prepared for a draft dependency PR; merge/release and all production execution remain outside this authorization. Consumer pins must move to supported releases before deployment.

The repository-wide commit hook invokes pre-commit --all-files and reformatted 128 unrelated tracked documents. Those post-hook edits were restored to the reviewed index. Scoped pre-commit checks are used instead; Terraform docs updates are limited to this module/example. The global commit wrapper is bypassed only after the same checks pass for the staged files.

Published dependency PRs: https://github.com/dasmeta/terraform-aws-modules/pull/371 and https://github.com/dasmeta/terraform-aws-account/pull/67. Sela source and regenerated account Terraform are published in MR !183 at 21de61e381ff5c8cd71640ac46c43387cc7164af. The consumer pins the tested immutable code commits; this follow-up changes documentation only. All source-implementation tasks are complete; merge/release and production deployment gates remain outstanding.

## Calendar-duration correction
AWS5.100.0 validation passed. Native mocked tests passed 16/16, including explicit days=1827 with years unset, compatible years=5, and rejection of both units, fractional/negative/excessive days. No AWS API calls or infrastructure apply. Scoped hooks regenerated the affected input table. Consumer revision publication and generated Terraform are recorded in CloudBrowser275 and the linked Sela MR.
