# Output the S3 bucket name
output "firehose_waf_delivery_arn" {
  description = "The name of the S3 bucket"
  value       = aws_iam_role.firehose_waf_delivery_role.arn
}