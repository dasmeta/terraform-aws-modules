locals {
  queue_name   = var.fifo_queue ? "${var.name}.fifo" : var.name
  iam_username = "sqs-queue-${var.name}-usr"
}
