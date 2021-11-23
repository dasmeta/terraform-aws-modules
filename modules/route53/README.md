# HOW TO
You can use module use when you create zones and add records in creating a zone.
Module output zone id and zone arn.

Example 1. You can create only zone 

module "route53" {

    source = "/Users/juliaaghamyan/Desktop/test_route53/route53"
    zone = "test1.devops.dasmeta.com"
    ttl = "30"
}


Example 2. Create zone and add one record. 
Note. Your recordid must be unique

module "route53" {

    source = "/Users/juliaaghamyan/Desktop/test_route53/route53"
    zone = "test.example.com"
    type_record = [
        {
            recordid = "1"
            recordname = "test.example.com"
            recordtype = "A"
            recordvalue = ["192.168.0.2"]
        }
    ]
    ttl = "30"
}

Example 2. Create zone and more record and more record value

module "route53" {

    source = "/Users/juliaaghamyan/Desktop/test_route53/route53"
    zone = "test.example.com"
    type_record = [
        {
            recordid = "1"
            recordname = "test.example.com"
            recordtype = "A"
            recordvalue = ["192.168.0.2"]
        },
        {
            recordid = "2"
            recordname = "test.example.com"
            recordtype = "MX"
            recordvalue = ["1 mail1","2 mail2"]
        }
    ]
    ttl = "30"
}