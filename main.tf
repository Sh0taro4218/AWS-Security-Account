terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 1. 管理アカウント用のProvider
provider "aws" {
  region = var.aws_region
}

# 管理アカウント自身の SecurityHub 有効化
resource "aws_securityhub_account" "management" {}

# 監査アカウントを SecurityHub の委任管理者に指定
resource "aws_securityhub_organization_admin_account" "delegated_admin" {
  admin_account_id = var.audit_account_id

  depends_on = [aws_securityhub_account.management]
}