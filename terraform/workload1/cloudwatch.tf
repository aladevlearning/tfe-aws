resource "aws_cloudwatch_log_group" "firehose" {
  name              = "/aws/kinesisfirehose/cloudfront-realtime-logs-to-s3"
  retention_in_days = 14
}


