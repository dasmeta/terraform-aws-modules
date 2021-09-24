data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_security_group" "sg" {
  name = "${var.name}-postgres-sg"
  description = "Allow inbound traffic to Postgres from VPC CIDR"
  vpc_id = data.aws_vpc.vpc.id

  ingress {
    from_port = 0
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = concat(
      [
        data.aws_vpc.vpc.cidr_block
      ],
      var.ip_ranges
    )
  }
}