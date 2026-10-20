# Interface
bucket_protection: force_destroy (bool), versioning_enabled (bool), governance_retention_years (number,0 disables), governance_bypass_role_arns (list of concrete role ARNs). Account exposes it under cloudtrail.

Existing bucket/trail identities and resource addresses do not change. Added configuration resources refer to the same bucket ID. New default protection does not alter old object versions. Approval is procedural and external to Terraform IAM evaluation.
