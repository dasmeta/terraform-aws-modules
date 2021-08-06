# How to
1. describe your widgets in widgets.json file
2. run

```
module "cloudwatch" {
  source = "git::https://github.com/dasmeta/terraform.git//modules/cloudwatch?ref="

  dashboard_name = "cloudwatch dashboard name"
  body_file_name = "some json file name"
}
