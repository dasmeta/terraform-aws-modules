# todo
- Terraform the creation of AWS ECR objects.

## Usage

**IMPORTANT:** 
Repository names can have minimum 2 and maximum 256 characters. The name must start with a letter and can only contain lowercase letters, numbers, hyphens, underscores, and forward slashes.

# Case 1
```
module "ecr" {
     source  = "dasmeta/modules/aws//modules/ecr"
     repos = ["repo1"]
}
```

# Case 2
```
module "ecr" {
     source  = "dasmeta/modules/aws//modules/ecr"
     repos = ["repo1", "repo2", "repo3"]
}
```
