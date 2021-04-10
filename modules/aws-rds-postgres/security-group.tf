data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_security_group" "sg" {
  name = "${var.name}-postgres-sg"
  description = "Allow inbound traffic to Postgres from VPC CIDR"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      data.aws_vpc.vpc.cidr_block
    ]
  }
}