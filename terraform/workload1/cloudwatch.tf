resource "aws_cloudwatch_log_group" "firehose" {
  name              = "/aws/kinesisfirehose/cloudfront-realtime-logs-to-s3"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_stream" "firehose_logs_stream" {
  name           = "firehose-error-stream"
  log_group_name = aws_cloudwatch_log_group.firehose.name
}