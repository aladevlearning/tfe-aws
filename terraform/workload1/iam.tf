data "aws_partition" "current" {}
data "aws_region" "current" {}

resource "aws_iam_role" "firehose_delivery" {
  name     = "firehose-delivery-role-cloudfront"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "firehose.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "firehose_delivery" {
  name     = "firehose-delivery-policy-cloudfront"
  role     = aws_iam_role.firehose_delivery.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "S3Access",
        Effect: "Allow",
        Action: ["s3:AbortMultipartUpload","s3:GetBucketLocation","s3:GetObject","s3:ListBucket","s3:ListBucketMultipartUploads","s3:PutObject"],
        Resource: [var.logging_bucket_arn, "${var.logging_bucket_arn}/*"]
      },
      {
        Sid: "KinesisAccess",
        Effect: "Allow",
        Action: ["kinesis:DescribeStream","kinesis:DescribeStreamSummary","kinesis:GetRecords","kinesis:GetShardIterator","kinesis:ListShards","kinesis:SubscribeToShard"],
        Resource: aws_kinesis_stream.cloudfront_realtime.arn
      },
      {
        Effect: "Allow",
        Action: [
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Resource: "${aws_cloudwatch_log_group.firehose.arn}:*"
      }
    ]
  })
}

# Role used by CloudFront real-time logging to write records into the Kinesis Data Stream
resource "aws_iam_role" "cloudfront_realtime_writer" {
  name = "cloudfront-realtime-writer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { Service = "cloudfront.amazonaws.com" },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudfront_realtime_writer" {
  name = "cloudfront-realtime-writer-policy"
  role = aws_iam_role.cloudfront_realtime_writer.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "AllowWriteToKinesisStream",
        Effect: "Allow",
        Action: [
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary",
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ],
        Resource: aws_kinesis_stream.cloudfront_realtime.arn
      }
    ]
  })
}


