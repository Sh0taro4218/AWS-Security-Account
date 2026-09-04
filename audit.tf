# 2. 監査アカウント用 Provider (AssumeRoleで権限切り替え)
provider "aws" {
  alias  = "audit"
  region = var.aws_region

  assume_role {
    role_arn = "arn:aws:iam::${var.audit_account_id}:role/${var.audit_role_name}"
  }
}

# 監査アカウント自身の SecurityHub 有効化
resource "aws_securityhub_account" "audit" {
  provider = aws.audit
}

# 組織配下（本番・検証など）の自動有効化＆自動連携設定
resource "aws_securityhub_organization_configuration" "auto_enable" {
  provider = aws.audit

  auto_enable           = true       # 既存・新規アカウントを自動連携
  auto_enable_standards = "DEFAULT"  # ベストプラクティスルールを自動適用

  depends_on = [
    aws_securityhub_account.audit,
    aws_securityhub_organization_admin_account.delegated_admin
  ]
}

# セキュリティ基準の追加（例: AWS Foundational Security Best Practices）
resource "aws_securityhub_standards_subscription" "aws_foundational" {
  provider      = aws.audit
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/aws-foundational-security-best-practices/v/1.0.0"

  depends_on = [aws_securityhub_account.audit]
}