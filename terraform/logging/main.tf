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

resource "aws_cloudwatch_log_delivery" "this" {
  delivery_source_name     = var.aws_cloudwatch_log_delivery_source_name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.s3.arn

  s3_delivery_configuration {
    suffix_path = "/Logs/{DistributionId}/{yyyy}/{MM}/{dd}/{HH}"
  }
}

resource "aws_cloudwatch_log_delivery_destination" "s3" {
  name          = "mydestination-logs"
  output_format = "plain"

  delivery_destination_configuration {
    destination_resource_arn = "${module.access_logs_bucket.bucket_arn}/CloudFrontLogs"
  }
}