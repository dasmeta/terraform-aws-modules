# allows to create S3 bucket content by syncing all the files in local folder to s3 as separate state having item
# TODO: have this as submodule int our future s3 separate module

## example how it can be used
```hcl
module "bucket_files" {
  source = "{path-to-this-module-root}/objects"

  bucket  = "my-bucket"
  path    = "./my-files/"
}
```