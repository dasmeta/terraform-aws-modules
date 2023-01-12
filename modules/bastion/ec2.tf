module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "bastion"

  ami                    = module.ami.ubuntu
  instance_type          = "t2.micro"
  key_name               = var.key_name
  monitoring             = false
  vpc_security_group_ids = [module.security-group-ssh.security_group_id]
  subnet_id              = data.aws_subnets.all.ids[0]
  source_dest_check      = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Purpose     = "bastion"
  }
}
