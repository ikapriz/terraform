terraform {
 backend "s3" {
   key = "qa/tfstate"
   region = "us-east-1"
   bucket = "ngc-qa-terraform-state"
   dynamodb_table = "ngc-terraform-qa"
   encrypt = true
 }
}
