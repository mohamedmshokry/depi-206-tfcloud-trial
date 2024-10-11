provider "aws" {
  region = "eu-north-1"
}

# terraform {
#   backend "s3" {
#     bucket = "depi-206-tf-remote-backend-trial"
#     key    = "terraform.tfstate"
#     region = "eu-north-1"
#     dynamodb_table = "terraform-state-lock-dynamodb"
#   }
# }