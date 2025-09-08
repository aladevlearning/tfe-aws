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
  iam_role_firehose_arn = var.iam_role_waf_firehose_arn
  providers = {
    aws = aws
  }
}

module "access_logs_bucket" {
  source       = "../modules/s3"
  bucket_name = "access-logs"
  iam_role_firehose_arn = var.iam_role_real_time_firehose_arn
  providers = {
    aws = aws
  }
}

module "real_time_logs_bucket" {
  source       = "../modules/s3"
  bucket_name = "real-time-logs"
  iam_role_firehose_arn = var.iam_role_real_time_firehose_arn
  providers = {
    aws = aws
  }
}
