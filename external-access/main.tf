terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "cys-test-terraform-eu-north-1"
    key    = "external-access/terraform.tfstate"
    region = "eu-north-1"
  }
}

provider "aws" {
  allowed_account_ids = ["044102971343"]
  region              = "eu-north-1"
  default_tags {
    tags = {
      project = "external-access"
    }
  }
}

data "aws_caller_identity" "current" {}
