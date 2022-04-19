variable "name" {
  type        = string
  description = "Bucket name."
}

variable "acl" {
  type        = string
  default     = "private"
  description = "The acl config for bucket, NOTE: 'acl' conflicts with 'grant' and 'owner'."
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
  default     = true
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
    "s3:PutLifecycleConfiguration"
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

