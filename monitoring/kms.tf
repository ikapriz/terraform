

module "kms-share-multi-accounts" {
  source  = "/vagrant/terraform-aws-kms-share-multi-accounts-master"
  #version = "1.0.0"
  key_name = "testing-ami-sharing"
  src_account_ids  = ["533689996463"]
  dest_account_ids = ["118962990946"]
}
