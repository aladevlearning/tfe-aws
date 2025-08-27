resource "aws_kinesis_stream" "cloudfront_realtime" {
  name             = "cloudfront-realtime-logs"
  shard_count      = 1
  retention_period = 24
  stream_mode_details { stream_mode = "PROVISIONED" }
  tags = { Name = "cloudfront-realtime-logs" }
}

resource "aws_kinesis_firehose_delivery_stream" "cloudfront_realtime_logs" {
  name        = "cloudfront-realtime-logs-to-s3"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.cloudfront_realtime.arn
    role_arn           = aws_iam_role.firehose_delivery.arn
  }

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_delivery.arn
    bucket_arn         = var.logging_bucket_arn
    compression_format = "GZIP"
    error_output_prefix = "firehose/cloudfront/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    prefix              = "firehose/cloudfront/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/cloudfront-realtime-logs-to-s3"
      log_stream_name = "S3Delivery"
    }
  }
}

output "cloudfront_realtime_kinesis_stream_arn" {
  value = aws_kinesis_stream.cloudfront_realtime.arn
}

output "cloudfront_kinesis_source_role_arn" {
  value = aws_iam_role.firehose_source.arn
}

output "cloudfront_firehose_delivery_stream_arn" {
  value = aws_kinesis_firehose_delivery_stream.cloudfront_realtime_logs.arn
}


