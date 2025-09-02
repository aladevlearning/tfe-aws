# Origin Access Control for CloudFront to access S3
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "s3-oac-${aws_s3_bucket.content.id}"
  description                       = "OAC for S3 bucket ${aws_s3_bucket.content.id}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.content.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
    origin_id                = "S3-${aws_s3_bucket.content.id}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ${aws_s3_bucket.content.id}"
  default_root_object = "index.html"

  # Default cache behavior
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.content.id}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    realtime_log_config_arn = aws_cloudfront_realtime_log_config.cf_realtime_logs.arn

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Additional cache behavior for API endpoints (optional)
  ordered_cache_behavior {
    path_pattern           = "/api/*"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "S3-${aws_s3_bucket.content.id}"
    compress               = true
    viewer_protocol_policy = "https-only"
    realtime_log_config_arn = aws_cloudfront_realtime_log_config.cf_realtime_logs.arn

    forwarded_values {
      query_string = true
      headers      = ["Authorization", "CloudFront-Forwarded-Proto"]
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  # Price class - use PriceClass_100 for cheapest (US, Canada, Europe)
  price_class = "PriceClass_100"

  # Geographic restrictions (optional)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # SSL certificate
  viewer_certificate {
    cloudfront_default_certificate = true
    # For custom domain, use:
    # acm_certificate_arn      = aws_acm_certificate.cert.arn
    # ssl_support_method       = "sni-only"
    # minimum_protocol_version = "TLSv1.2_2021"
  }

  lifecycle {
    ignore_changes = [
      web_acl_id,  # ignore updates caused by FMS policy attachment
    ]
  }

  tags = {
    Name        = "CloudFront-${aws_s3_bucket.content.id}"
    Environment = "Dev"
    "FMSProtected" = "true"
  }
}

resource "aws_cloudfront_realtime_log_config" "cf_realtime_logs" {
  name          = "cf-realtime-logs"
  sampling_rate = 100
  fields        = ["timestamp","c-ip","time-to-first-byte","sc-status","sc-bytes","cs-method","cs-protocol","cs-host","cs-uri-stem","cs-bytes","x-edge-location","x-edge-result-type","x-edge-request-id","x-edge-detailed-result-type","ssl-protocol","ssl-cipher","x-edge-response-result-type","fle-encrypted-fields","fle-status","c-port","time-taken","x-forwarded-for","cs-cookie","cs-user-agent","cs-referer","cs-uri-query"]

  endpoint {
    stream_type = "Kinesis"
    kinesis_stream_config {
      role_arn   = aws_iam_role.cloudfront_realtime_writer.arn
      stream_arn = aws_kinesis_stream.cloudfront_realtime.arn
    }
  }
}

# Update S3 bucket policy to allow CloudFront access
resource "aws_s3_bucket_policy" "content_policy" {
  bucket = aws_s3_bucket.content.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.content.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}

resource "aws_cloudwatch_log_delivery_source" "this" {
  name         = "name"
  log_type     = "ACCESS_LOGS"
  resource_arn = aws_cloudfront_distribution.s3_distribution.arn
}


# Outputs

output "aws_cloudwatch_log_delivery_source_name" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudwatch_log_delivery_source.this.name
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.id
}

output "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.arn
}

output "cloudfront_distribution_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_distribution_zone_id" {
  description = "The CloudFront Route 53 zone ID"
  value       = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}