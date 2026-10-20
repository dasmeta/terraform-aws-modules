# Research decisions

- Use standalone Object Lock configuration; do not set bucket-level object_lock_enabled because AWS provider5 marks that bucket attribute ForceNew. Standalone creation calls PutObjectLockConfiguration against the existing bucket.
- Add explicit dependency on versioning. AWS versioning propagation guidance is a rollout consideration, not a reason to invent a fixed Terraform sleep.
- Provider5.0 already has the standalone implementation; test with Sela's AWS5 context and do not raise provider bounds without need.
- Child and account already use optional attributes; follow that established grouped-field convention without a new version floor.
- Keep default force_destroy=true for unrelated existing consumers; Sela explicitly opts out. Changing the global default would be a separate breaking/safety migration.
- Empty bypass list means no exception; omit the condition rather than sending an empty IAM condition array.
- Existing module behavior/code is the closest supported implementation; no provider wrapper replacement or resource ownership migration is needed.

Sources:
https://github.com/hashicorp/terraform-provider-aws/blob/v5.100.0/website/docs/r/s3_bucket_object_lock_configuration.html.markdown
https://github.com/hashicorp/terraform-provider-aws/blob/v5.100.0/internal/service/s3/bucket.go
https://github.com/hashicorp/terraform-provider-aws/blob/v5.0.0/internal/service/s3/bucket_object_lock_configuration.go
https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lock-configure.html
https://docs.aws.amazon.com/AmazonS3/latest/userguide/manage-versioning-examples.html

CloudBrowser record275 was read before source work. Its recorded missing-module gap is the reason for this bounded extension; current records do not claim live deployment.
