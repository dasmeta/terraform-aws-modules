# aws S3 bucket and iam user with access to it

Creates AWS S3 bucket and if there is need IAM user with appropriated accesses to list/get/put/delete objects in it.

# Use Cases

## Case 1: simple use case with minimal params

```terraform

module "my_bucket" {
  source = "dasmeta/modules/aws//modules/s3"
  version = "0.26.0"

  name = "my-files-bucket"
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = module.my_bucket.iam_access_key_id
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = module.my_bucket.iam_user_arn
}
```

## Case 2: with some additional params, by disabling iam user creation

```terraform
module "my_bucket" {
  source = "dasmeta/modules/aws//modules/s3"
  version = "0.26.0"

  name = "my-files-bucket"

  create_iam_user = false

  acl    = "public-read"

  versioning = {
    enabled = true
  }

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }
}
```
## Case 3: website with initial index.html and "/images/**" content
```terraform
module "my_bucket" {
  source = "dasmeta/modules/aws//modules/s3"
  version = "0.36.2"

  name = "my-website"

  versioning = {
    enabled = true
  }

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }

  create_index_html = true
  bucket_files = "{module.path}/images"
}
```
