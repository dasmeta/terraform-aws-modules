# How
```
module "ssl-certificate" {
  source      = "../terraform/modules/aws-ssl-certificate"
  zone_id = "zone id"
  domains =   ["sub1.example.com", "sub2.example.com", "sub3.example.com"]
}
