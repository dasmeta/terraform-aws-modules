# How to use

Case 1. Create Security group and create RDS
```
data "aws_vpc" "main" {
  id = "vpc-04c3b2abe39cd8a6a"
}

module "rds" {
    source  = "../../terraform-aws-modules/modules/rds"
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "mysql"
    engine_version       = "5.7.26"
    instance_class       = "db.t2.micro"
    identifier           = "db"
    db_name              = "db"
    db_username          = "root"
    db_password          = "foobarbazdocs.query.me"
    parameter_group_name = "default.mysql5.7"
    vpc_id               = "${data.aws_vpc.main.id}"
    subnet_ids           = ["subnet-04ad8ad2fdec889ec","subnet-0ea0a01c1bea0a0c9"]

    create_security_group = true
    ingress_with_cidr_blocks = [
    {
        description = "3306 from VPC"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = "${data.aws_vpc.main.cidr_block}"
    }]

    egress_with_cidr_blocks = [
        {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks ="[0.0.0.0/0]"
    }]
}
```
Case 2. Create RDS
```
module "rds" {
    source  = "../../terraform-aws-modules/modules/rds"
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "mysql"
    engine_version       = "5.7.26"
    instance_class       = "db.t2.micro"
    identifier           = "db"
    db_name              = "db"
    db_username          = "root"
    db_password          = "foobarbazdocs.query.me"
    parameter_group_name = "default.mysql5.7"

    vpc_id                 = "vpc-04c3b2abe39cd8a6a"
    subnet_ids             = ["subnet-04ad8ad2fdec889ec","subnet-0ea0a01c1bea0a0c9"]

    create_security_group = false
//  vpc_security_group_ids = ["sg-062742ac7a7f8c7a7"]
}
```