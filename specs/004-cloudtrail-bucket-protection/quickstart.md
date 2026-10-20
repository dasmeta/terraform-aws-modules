# Verification
Run terraform init -backend=false before validate and terraform test. Use mocked AWS providers, no credentials and no infrastructure apply. Native tests must be placed directly in tests/ at the module root, not hidden in case subdirectories. Preserve the runtime Terraform floor.

Before production: replace draft commit pins with supported releases, review an existing-state zero-replacement plan, approve exact changes, verify versioning/lock/bypass controls and continuing CloudTrail delivery. Capture an independently approved historical-version protection plan. Never automatically remove lock or shorten retention on rollback.
