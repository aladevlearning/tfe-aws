
variable "cloudfront_realtime_kinesis_stream_arn" {
  description = "Optional: ARN of the Kinesis Data Stream used by CloudFront real-time logs"
  type        = string
  default     = ""
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

