# HOW TO
You can use module use when you create zones and add records.
Module output zone id and zone arn.

## Example 1. create only zone
```terraform
module "route53" {
    source = "dasmeta/modules/aws//modules/route53"
    version = "0.21.17"

    zone = "example.com"
}
```

## Example 2. Create zone and add one record
```terraform
module "route53" {
    source  = "dasmeta/modules/aws//modules/route53"
    version = "0.21.17"

    zone    = "test.example.com"
    records = [
        {
            name  = "test.example.com"
            type  = "A"
            value = ["192.168.0.2"]
        }
    ]
    ttl = "30"
}
```

## Example 3. Create zone and more that one records

Note. Your record names must be unique

```terraform
module "route53" {
    source = "dasmeta/modules/aws//modules/route53"
    version = "0.21.17"

    zone = "example.com"
    records = [
        {
            name  = "test1.example.com"
            type  = "A"
            value = ["192.168.0.2"]
        },
        {
            name  = "test2.example.com"
            type  = "MX"
            value = ["1 mail1","2 mail2"]
        }
    ]
    ttl = "30"
}
```

## Example 4. Create only records
```terraform
module "route53" {
    source = "dasmeta/modules/aws//modules/route53"
    version = "0.21.17"

    zone = "example.com"
    create_zone = false
    records = [
        {
            name  = "test1.example.com"
            type  = "A"
            value = ["192.168.0.2"]
        },
        {
            name  = "test2.example.com"
            type  = "MX"
            value = ["1 mail1","2 mail2"]
        }
    ]
    ttl = "30"
}
```
