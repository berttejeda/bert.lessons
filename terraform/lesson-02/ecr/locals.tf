locals {
  ecr_image_repo_name         = "${var.aws_environment}/${var.image_name}"
  aws_account_id              = data.terraform_remote_state.vpc.outputs.aws_account_id 
  ecr_repo_kms_key_name       = "${var.aws_environment}-${var.image_name}-kms-key"
  ecr_repo_kms_key_alias_name = "alias/${local.ecr_repo_kms_key_name}"
}

