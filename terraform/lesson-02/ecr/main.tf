data "aws_iam_policy_document" "ecr_repo_kms_policy" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.aws_account_id}:root"]
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow access for Key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.aws_account_id}:root"]
    }
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.aws_account_id}:root"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.aws_account_id}:root"]
    }
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
  
}

resource "aws_kms_key" "ecr_repo" {
  description             = "${local.ecr_image_repo_name} - AWS ECR KMS Encryption Key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.ecr_repo_kms_policy.json
}

resource "aws_kms_alias" "ecr_repo" {
  name          = local.ecr_repo_kms_key_alias_name
  target_key_id = aws_kms_key.ecr_repo.key_id
}

resource "aws_ecr_repository" "ecr_repo" {
  name    = local.ecr_image_repo_name
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push         = true
  }  
  
  encryption_configuration {
    encryption_type = "KMS"
    kms_key = aws_kms_key.ecr_repo.arn
  }  

  tags    = {
    Name = local.ecr_image_repo_name
  }

}

data "aws_iam_policy_document" "ecr_repo_policy_document" {
  statement {
    sid    = "ECR Policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.aws_account_id}:root"]
    }    

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "ecr_repo_policy" {
  repository = aws_ecr_repository.ecr_repo.name
  policy     = data.aws_iam_policy_document.ecr_repo_policy_document.json
}

data "aws_ecr_lifecycle_policy_document" "ecr_repo_lifecycle_policy" {
  rule {
    priority    = 1
    description = "Default Lifecycle Rule"

    selection {
      tag_status      = "any"
      count_type      = "imageCountMoreThan"
      count_number    = 100
    }
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_repo_lifecycle_policy" {
  repository = aws_ecr_repository.ecr_repo.name
  policy     = data.aws_ecr_lifecycle_policy_document.ecr_repo_lifecycle_policy.json
}