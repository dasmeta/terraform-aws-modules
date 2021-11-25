# HOW TO
You can use module use when you create zones and add records in creating a zone.
Module output zone id and zone arn.

Example 1. You can create only zone 

module "route53" {

    source = "dasmeta/modules/aws//modules/route53"
    zone = "test1.example.com"
    ttl = "30"
}


Example 2. Create zone and add one record. 
Note. Your recordid must be unique

module "route53" {

    source  = "dasmeta/modules/aws//modules/route53"
    zone    = "test.example.com"
    records = [
        {
            id    = "1"
            name  = "test.example.com"
            type  = "A"
            value = ["192.168.0.2"]
        }
    ]
    ttl = "30"
}

Example 3. Create zone and more record and more record value

module "route53" {

    source = "dasmeta/modules/aws//modules/route53"
    zone = "test.example.com"
    records = [
        {
            id    = "1"
            name  = "test.example.com"
            type  = "A"
            value = ["192.168.0.2"]
        },
        {
            id    = "2"
            name  = "test.example.com"
            type  = "MX"
            value = ["1 mail1","2 mail2"]
        }
    ]
    ttl = "30"
}
