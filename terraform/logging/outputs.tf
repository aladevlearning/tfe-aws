output "access_logs_bucket_name" {
  value = module.access_logs_bucket.bucket_name
}

output "access_logs_bucket_arn" {
  value = module.access_logs_bucket.bucket_arn
}

output "real_time_logs_bucket_name" {
  value = module.real_time_logs_bucket.bucket_name
}

output "real_time_logs_bucket_arn" {
  value = module.real_time_logs_bucket.bucket_arn
}

output "waf_logs_bucket_name" {
  value = module.waf_logs_bucket.bucket_name
}

output "waf_logs_bucket_arn" {
  value = module.waf_logs_bucket.bucket_arn
}
