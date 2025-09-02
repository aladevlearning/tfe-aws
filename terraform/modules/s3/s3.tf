resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Create the S3 bucket
resource "aws_s3_bucket" "this" {
  bucket = "${var.bucket_name}-${random_string.bucket_suffix.result}"

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
  }
}

# Enforce bucket owner controls (no ACLs from others)
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_firehose_put" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "AllowFirehosePutFromOtherAccounts",
        Effect: "Allow",
        Principal: { AWS: var.iam_role_arn },
        Action: [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        Resource: [aws_s3_bucket.this.arn, "${aws_s3_bucket.this.arn}/*"]
      }
    ]
  })
}
data "aws_cloudfront_log_delivery_canonical_user_id" "cloudfront" {}

# Bucket ACL for CloudFront logging
resource "aws_s3_bucket_acl" "access_logs" {
  depends_on = [aws_s3_bucket_ownership_controls.this]
  bucket     = var.bucket_name

  grant {
    id         = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id
    permission = "FULL_CONTROL"
    type       = "CanonicalUser"
  }
}

# Optional: versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}
