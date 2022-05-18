
### Create AWS group and set ReadOnly permission.

## Example 1. Minimal parameter set and create permissions

```
module "test-read-only" {
  source = "dasmeta/modules/aws//modules/iam-read-only"
  attach_users_to_group = false
}
```

## Example 2. Maxsimum parameter set and create permissions

```
module "test-read-only" {
  source = "dasmeta/modules/aws//modules/iam-read-only"
  name   = "ReadOnlyTest"
  users  = ["test"]
}
```
