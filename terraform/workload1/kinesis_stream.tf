resource "aws_kinesis_stream" "cloudfront_realtime" {
  provider         = aws.aws_use1
  name             = "cloudfront-realtime-logs"
  shard_count      = 1
  retention_period = 24
  stream_mode_details { stream_mode = "PROVISIONED" }
  tags = { Name = "cloudfront-realtime-logs" }
}

output "cloudfront_realtime_kinesis_stream_arn" {
  value = aws_kinesis_stream.cloudfront_realtime.arn
}


