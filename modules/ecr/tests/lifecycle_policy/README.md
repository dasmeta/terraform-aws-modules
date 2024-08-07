# lifecycle_policy

This example creates 1 repository and changes lifecycle policy for it, that is:
1. Protects images tagged with `prod`.
2. Protects images tagged with `stage`.
3. Remove untagged images.
4. Rotate images when reach 100 images stored.

To change limit of images with unprotected tags, change `max_image_count` value.
To change tags for imgaes, change `protected_tags` value.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.22.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
