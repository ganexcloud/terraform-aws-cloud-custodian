variable "name" {
  description = "Name of resources"
  type        = string
  default     = "cloud-custodian"
}

variable "iam_extra_policy" {
  description = "(Optional) IAM User extra policy. This is a JSON formatted string."
  type        = string
  default     = null
}

variable "lambda_extra_policy" {
  description = "(Optional) Lambda role extra policy. This is a JSON formatted string."
  type        = string
  default     = null
}

variable "ses_arn" {
  description = "SES domain ARN, used to send emails."
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name to store cloud-custodian logs."
  type        = string
}
