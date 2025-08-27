terraform {
  required_version = ">= 1.10.0" # Ensure that the Terraform version is 1.10.0 or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
      configuration_aliases = [aws.workload1_euw1, aws.security_euw1, aws.security_use1]
    }
  }

  backend "s3" {
    bucket         = "terraform-cicd-state-slsmlnb9"  # S3 bucket in Account A
    key            = "states/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-cicd-state-lock"
  }
}

module "workload1" {
  source       = "./workload1"

  providers = {
    aws = aws.workload1_euw1
  }
}

module "security" {
  source       = "./security"
  workload1_account_id = var.workload1_account_id
  security_account_id = var.security_account_id
  providers = {
    aws = aws.security_euw1
    aws.security_use1 = aws.security_use1
  }
}

module "logging" {
  source       = "./logging"

  providers = {
    aws = aws.logging_euw1
  }
}