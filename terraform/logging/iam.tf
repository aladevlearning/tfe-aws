resource "aws_iam_role" "firehose_delivery" {
  name     = "firehose-delivery-role-cloudfront-central"

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
  name     = "firehose-delivery-policy-cloudfront-central"
  role     = aws_iam_role.firehose_delivery.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "S3Access",
        Effect: "Allow",
        Action: ["s3:AbortMultipartUpload","s3:GetBucketLocation","s3:GetObject","s3:ListBucket","s3:ListBucketMultipartUploads","s3:PutObject"],
        Resource: [aws_s3_bucket.logging.arn, "${aws_s3_bucket.logging.arn}/*"]
      },
      {
        Sid: "KinesisAccessCrossAccount",
        Effect: "Allow",
        Action: ["kinesis:DescribeStream","kinesis:DescribeStreamSummary","kinesis:GetRecords","kinesis:GetShardIterator","kinesis:ListShards","kinesis:SubscribeToShard"],
        Resource: var.cloudfront_realtime_kinesis_stream_arn
      }
    ]
  })
}


