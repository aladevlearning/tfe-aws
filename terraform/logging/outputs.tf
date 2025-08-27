output "logging_bucket_name" {
  value = aws_s3_bucket.logging.bucket
}

output "logging_bucket_arn" {
  value = aws_s3_bucket.logging.arn
}

// No Firehose outputs by default; not needed for referencing from other modules


