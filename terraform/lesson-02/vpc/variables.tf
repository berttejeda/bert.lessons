variable "aws_account_id" {
  description = "The AWS Account ID"
  type        = string
}

variable "aws_environment" {
  description = "The Environment context, e.g. dev, stage, prod"
  type = string
}

variable "aws_region" {
  description = "The AWS Region to operate in"
  type = string
}

variable "vpc_cidr_block" {
  description = "The VPC Network CIDR Block"
  type        = string
}

variable "vpc_name" {
  description = "The Name of the VPC"
  type        = string
}