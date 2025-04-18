provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]
  default_tags {
    tags = {
      terraform_codebase = basename(path.module)
    }
  }
}
