terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

module "waf_logs_bucket" {
  source       = "../modules/s3"
  bucket_name = "waf-logs"
  iam_role_arn = aws_iam_role.firehose_delivery.arn
  providers = {
    aws = aws
  }
}

module "access_logs_bucket" {
  source       = "../modules/s3"
  bucket_name = "access-logs"
  iam_role_arn = aws_iam_role.firehose_delivery.arn
  providers = {
    aws = aws
  }
}

module "real_time_logs_bucket" {
  source       = "../modules/s3"
  bucket_name = "real-time-logs"
  iam_role_arn = aws_iam_role.firehose_delivery.arn
  providers = {
    aws = aws
  }
}