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
    object_ownership = "BucketOwnerPreferred"
  }
}

data "aws_canonical_user_id" "current" {}

data "aws_canonical_user_id" "current" {}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  access_control_policy {
    grant {
      grantee {
        id   = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }

    grant {
      grantee {
        type = "Group"
        uri  = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission = "FULL_CONTROL"
    }

    owner {
      id = data.aws_canonical_user_id.current.id
    }
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
      },
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            "arn:aws:iam::559672757117:root"
          ]
        },
        "Action": [
          "s3:GetBucketAcl",
          "s3:PutBucketAcl"
        ],
        "Resource": aws_s3_bucket.this.arn
      }
    ]
  })
}

# Optional: versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}


/*resource "aws_cloudwatch_log_delivery_destination_policy" "s3" {
  delivery_destination_name = aws_cloudwatch_log_delivery_destination.s3.name
  delivery_destination_policy = data.aws_iam_policy_document.delivery_destination_policy.json
}*/