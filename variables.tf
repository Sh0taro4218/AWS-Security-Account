variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "audit_account_id" {
  type        = string
  description = "監査アカウントの12桁のアカウントID"
}

variable "audit_role_name" {
  type        = string
  default     = "OrganizationAccountAccessRole"
  description = "管理アカウントから監査アカウントに切り替えるためのIAMロール名"
}
