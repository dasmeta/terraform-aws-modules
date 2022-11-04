module "rabbitmq" {
  source = "dasmeta/modules/aws//modules/rabbitmq"

  broker_name        = "app-dev-mq"
  subnet_ids         = ["subnet-231dadsa344ds", "subnet-231dqweqsa344ds", "subnet-241dadsa344ds"]
  security_groups    = ["sg-asff234adasdd"]
  username           = "user-terraform"
  password           = "password@#$23da"
  engine_version     = "3.8.27"
  deployment_mode    = "SINGLE_INSTANCE"
  host_instance_type = "mq.t3.micro"
}
