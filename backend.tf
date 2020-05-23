terraform {
 backend "s3" {
 encrypt = true
 bucket = "equifax-ag-terraform-s3-05232020"
 region = "us-east-1"
 key = "terraform.tfstate"
 }
}