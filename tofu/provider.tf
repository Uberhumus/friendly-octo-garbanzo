# provider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "home-assignment-yotam"
    key            = "eks/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}
