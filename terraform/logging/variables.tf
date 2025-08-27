
variable "cloudfront_realtime_kinesis_stream_arn" {
  description = "Optional: ARN of the Kinesis Data Stream used by CloudFront real-time logs"
  type        = string
  default     = ""
}

variable "cloudfront_kinesis_source_role_arn" {
  description = "ARN of IAM role in the workload account that Firehose assumes to read from the Kinesis stream"
  type        = string
}

variable "workload1_firehose_delivery_stream_arn" {
  description = "ARN of the Firehose delivery stream in the workload account that writes to the logging bucket"
  type        = string
}

variable "create_cloudfront_realtime_kinesis_stream" {
  description = "If true and no ARN provided, create a Kinesis Data Stream for CloudFront real-time logs"
  type        = bool
  default     = true
}

variable "cloudfront_realtime_kinesis_shard_count" {
  description = "Shard count for the created CloudFront real-time Kinesis Data Stream"
  type        = number
  default     = 1
}

variable "workload1_account_id" { type = string }
variable "security_account_id" { type = string }

