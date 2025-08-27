resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create the S3 bucket
resource "aws_s3_bucket" "logging" {
  bucket = "static-logging-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "LoggingBucket"
    Environment = "Dev"
  }
}

# Enforce bucket owner controls (no ACLs from others)
resource "aws_s3_bucket_ownership_controls" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "logging" {
  bucket                  = aws_s3_bucket.logging.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_firehose_put" {
  bucket = aws_s3_bucket.logging.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "AllowFirehosePutFromOtherAccounts",
        Effect: "Allow",
        Principal: { Service: "firehose.amazonaws.com" },
        Action: ["s3:PutObject","s3:AbortMultipartUpload","s3:ListBucketMultipartUploads","s3:GetBucketLocation","s3:ListBucket"],
        Resource: [aws_s3_bucket.logging.arn, "${aws_s3_bucket.logging.arn}/*"],
        Condition: {
          StringEquals: {
            "aws:SourceAccount": [var.workload1_account_id, var.security_account_id]
          },
          ArnLike: {
            "aws:SourceArn": module.workload1.cloudfront_firehose_delivery_stream_arn
          }
        }
      }
    ]
  })
}

# Optional: versioning
resource "aws_s3_bucket_versioning" "logging" {
  bucket = aws_s3_bucket.logging.id

  versioning_configuration {
    status = "Enabled"
  }
}
