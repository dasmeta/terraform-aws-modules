variable "name" {
  type        = string
  description = "Bucket name."
}

variable "acl" {
  type        = string
  default     = null # "private"
  description = "The acl config for bucket, NOTE: 'acl' conflicts with 'grant' and 'owner'."
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = false
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = false
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = false
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = false
}

variable "grant" {
  type        = any
  default     = []
  description = "The ACL policy grant. NOTE: conflicts with 'acl'."
}

variable "owner" {
  type        = map(string)
  default     = {}
  description = "The Bucket owner's display name and ID. NOTE: Conflicts with 'acl'."
}

variable "create_iam_user" {
  type        = bool
  default     = false
  description = "Whether to create specific api access user to this created bucket."
}

variable "iam_user_actions" {
  type = list(string)
  default = [
    "s3:PutObject",
    "s3:ListBucket",
    "s3:GetObject",
    "s3:GetObjectVersion",
    "s3:GetBucketAcl",
    "s3:DeleteObject",
    "s3:DeleteObjectVersion",
    "s3:PutLifecycleConfiguration",
    "s3:PutObjectAcl"
  ]
  description = "The allowed actions that created user can perform on this created bucket."
}

variable "iam_user_name" {
  type        = string
  default     = ""
  description = "The name of user, NOTE: this is optional and if it is not passed in use place the name will be generated based on bucket name."
}

variable "versioning" {
  type        = map(string)
  default     = {}
  description = "The versioning configuration for the created bucket."
}

variable "website" {
  type        = map(string)
  default     = {}
  description = "The website configuration for the created bucket."
}

variable "create_index_html" {
  type        = bool
  default     = false
  description = "Whether to create and initial index.html file with default data."
}

variable "bucket_files" {
  type = object({
    path = string
  })
  default = {
    path = ""
  }
  description = "Initial content for bucket, use acl and pattern params if you need more control."
}
