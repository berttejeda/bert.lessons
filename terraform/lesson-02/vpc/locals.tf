locals {
  vpc_name       = "${var.aws_environment}-${var.vpc_name}"
  vpc_cidr_block = var.vpc_cidr_block
}