resource "aws_vpc" "this" {
  cidr_block           = local.vpc_cidr_block
  enable_dns_support   = true //gives you an internal domain name
  enable_dns_hostnames = true //gives you an internal host name
  instance_tenancy     = "default"
  tags                 = {
    Name = local.vpc_name
  }
}