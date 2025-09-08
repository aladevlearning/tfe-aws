resource "aws_kinesis_firehose_delivery_stream" "waf_logs" {
  name        = "firewall-manager-waf-logs-to-s3"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_waf_delivery_role.arn
    bucket_arn         = var.waf_logs_bucket_arn
    compression_format = "GZIP"
    error_output_prefix = "firehose/cloudfront/waf/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
    prefix              = "firehose/cloudfront/waf/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.firehose_waf.name
      log_stream_name = aws_cloudwatch_log_stream.firehose_waf_logs_stream.name
    }
  }
}


