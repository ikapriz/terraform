terraform {
  backend "s3" {
    key            = "dev/tfstate"
    region         = "us-east-1"
    bucket         = "ngc-dev-terraform-state"
    dynamodb_table = "ngc-terraform-dev"
    encrypt        = true
  }
}
