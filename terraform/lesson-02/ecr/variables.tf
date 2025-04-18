variable "aws_environment" {
  description = "The Environment context, e.g. dev, stage, prod"
  default     = "dev"
  type        = string
}


variable "aws_region" {
  description = "The AWS Region to operate in"
  default     = "us-east-1"
  type        = string
}


variable "terraform_state_bucket" {}

variable "image_name" {
  description = "The name of the container's docker image"
  default     = "busybox"
  type        = string
}