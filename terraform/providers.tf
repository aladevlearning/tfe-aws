# Default provider CICD
provider "aws" {
  region = "eu-west-1"
}

# Alias provider = assumes into workload account B
provider "aws" {
  alias  = "workload1_euw1"
  region = "eu-west-1"

  assume_role {
    role_arn = var.iam_role_workload1_tf_deployer_arn
  }
}

provider "aws" {
  alias  = "workload1_use1"
  region = "us-east-1"

  assume_role {
    role_arn = var.iam_role_workload1_tf_deployer_arn
  }
}

provider "aws" {
  alias  = "security_euw1"
  region = "eu-west-1"

  assume_role {
    role_arn = var.iam_role_security_tf_deployer_arn
  }
}

provider "aws" {
  alias  = "security_use1"
  region = "us-east-1"

  assume_role {
    role_arn = var.iam_role_security_tf_deployer_arn
  }
}

provider "aws" {
  alias  = "logging_euw1"
  region = "eu-west-1"

  assume_role {
    role_arn = var.iam_role_logging_tf_deployer_arn
  }
}

provider "aws" {
  alias  = "logging_use1"
  region = "us-east-1"

  assume_role {
    role_arn = var.iam_role_logging_tf_deployer_arn
  }
}