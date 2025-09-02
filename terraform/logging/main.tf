terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

data "aws_cloudfront_log_delivery_canonical_user_id" "cloudfront" {}

module "waf_logs_bucket" {
  source       = "../modules/s3"
  bucket_name = "waf-logs"
  aws_cloudwatch_log_delivery_source_name = var.aws_cloudwatch_log_delivery_source_name
  iam_role_arn = aws_iam_role.firehose_delivery.arn
  providers = {
    aws = aws
  }
}

module "access_logs_bucket" {
  source       = "../modules/s3"
  bucket_name = "access-logs"
  aws_cloudwatch_log_delivery_source_name = var.aws_cloudwatch_log_delivery_source_name
  iam_role_arn = aws_iam_role.firehose_delivery.arn
  providers = {
    aws = aws
  }
}

module "real_time_logs_bucket" {
  source       = "../modules/s3"
  bucket_name = "real-time-logs"
  aws_cloudwatch_log_delivery_source_name = var.aws_cloudwatch_log_delivery_source_name
  iam_role_arn = aws_iam_role.firehose_delivery.arn
  providers = {
    aws = aws
  }
}
