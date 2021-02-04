provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]
}

locals {
  common_tags = {
    environmnt = var.environment
    project    = var.project
  }
}
