output "iam_user_arn" {
  value       = join(",", aws_iam_user.this.*.arn)
  description = "The ARN of IAM user."
}

output "iam_user_name" {
  value       = join(",", aws_iam_user.this.*.name)
  description = "The Name of IAM user."
}

output "lambda_role_arn" {
  value       = join(",", aws_iam_role.lambda.*.arn)
  description = "The ARN of Lambda IAM role "
}

output "lambda_role_name" {
  value       = join(",", aws_iam_role.lambda.*.name)
  description = "The Name of Lambda IAM role "
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.this.id
  description = "S3 bucket name "
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "S3 bucket arn "
}

output "sqs_notifications-standard_name" {
  value       = aws_sqs_queue.standard.name
  description = "SQS notifications-standard name"
}

output "sqs_notifications-dlq_name" {
  value       = aws_sqs_queue.dlq.name
  description = "SQS notifications-dlq name"
}
