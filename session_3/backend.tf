terraform {
  backend "s3" {
    bucket = "iac-lab-sr-tfstate"
    key    = "ap-south-1/iac-lab-ashu/terraform.tfstate"
    region = "ap-southeast-2"

    dynamodb_table = "iac-lab-ashu-tfstate-locks"
    encrypt        = true
  }
}