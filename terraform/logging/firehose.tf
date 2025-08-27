data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

resource "aws_kinesis_firehose_delivery_stream" "cloudfront_realtime_logs" {
  provider   = aws.aws_use1
  name       = "cloudfront-realtime-logs-to-s3-central"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = var.cloudfront_realtime_kinesis_stream_arn
    role_arn           = aws_iam_role.firehose_delivery.arn
  }

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_delivery.arn
    bucket_arn         = aws_s3_bucket.logging.arn
    buffering_interval = 60
    buffering_size     = 5
    compression_format = "GZIP"
    error_output_prefix = "firehose/cloudfront/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    prefix              = "firehose/cloudfront/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
  }
}


