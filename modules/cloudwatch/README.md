# How to
1. assign your widgets to the widgets variable, but don't insert any "", so the right syntax is:
   widgets = {
    "widgets": [ ....
      ...
    ]
   }
2. run

```
module "cloudwatch" {
  source = "git::https://github.com/dasmeta/terraform.git//modules/cloudwatch?ref="

  dashboard_name = "cloudwatch dashboard name"
  widgets = "some json file"
}
