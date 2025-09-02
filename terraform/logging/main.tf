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
  cloudfront_log_delivery_canonical_user_id = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id
  iam_role_arn = aws_iam_role.firehose_delivery.arn
  providers = {
    aws = aws
  }
}

module "access_logs_bucket" {
  source       = "../modules/s3"
  bucket_name = "access-logs"
  cloudfront_log_delivery_canonical_user_id = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id
  iam_role_arn = aws_iam_role.firehose_delivery.arn
  providers = {
    aws = aws
  }
}

module "real_time_logs_bucket" {
  source       = "../modules/s3"
  bucket_name = "real-time-logs"
  cloudfront_log_delivery_canonical_user_id = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id
  iam_role_arn = aws_iam_role.firehose_delivery.arn
  providers = {
    aws = aws
  }
}