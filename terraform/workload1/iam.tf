data "aws_partition" "current" {}

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
        Sid: "LogsForDiagnostics",
        Effect: "Allow",
        Action: ["logs:PutLogEvents"],
        Resource: "arn:${data.aws_partition.current.partition}:logs:us-east-1:*:log-group:/aws/kinesisfirehose/*:log-stream:*"
      }
    ]
  })
}


