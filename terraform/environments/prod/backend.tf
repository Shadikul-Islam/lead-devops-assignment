terraform {
  backend "s3" {
    bucket         = "shadikul-terraform-state-001"
    key            = "eks/prod/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}