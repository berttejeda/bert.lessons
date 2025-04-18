data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "${var.terraform_state_bucket}"
    key    = "${var.aws_region}/vpc/terraform.tfstate"
    region = var.aws_region
  }
}