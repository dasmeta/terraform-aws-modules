mock_provider "aws" {}

mock_provider "kubernetes" {}

run "merges_logging_and_custom_attributes" {
  command = plan

  override_module {
    target = module.alb-to-cloudwatch[0]
  }

  variables {
    name                               = "test-ingress"
    hostname                           = "test.example.com"
    namespace                          = "default"
    enable_send_alb_logs_to_cloudwatch = true
    load_balancer_attributes           = "idle_timeout.timeout_seconds=600"

    alarms = {
      enabled   = false
      sns_topic = ""
    }
  }

  assert {
    condition     = output.annotations["alb.ingress.kubernetes.io/load-balancer-attributes"] == "access_logs.s3.enabled=true,access_logs.s3.bucket=alb-test-ingress-bucket,idle_timeout.timeout_seconds=600"
    error_message = "Managed access-log attributes and caller-provided ALB attributes must be combined into one annotation."
  }
}
