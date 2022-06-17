locals {
  fluent_name = var.fluent_bit_name != "" ? var.fluent_bit_name : "${var.cluster_name}-fluent-bit"
  bucket_name = var.bucket_name != "" ? var.bucket_name : "fluent-bit-bucket"
  region      = var.region
}
