output "s3_bucket_name" {
  description = "Example bucket name."
  value       = module.this.s3_bucket_name
}

output "sqs_standard_name" {
  description = "Example standard queue name."
  value       = module.this["sqs_notifications-standard_name"]
}
