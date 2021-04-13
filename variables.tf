variable "name" {
  description = "(Required) Name of resources"
  type        = string
  default     = "cloud-custodian"
}

variable "create_iam_user" {
  description = "(Required) Create iam user"
  type        = bool
  default     = true
}

variable "create_iam_role" {
  description = "(Required) Create iam role"
  type        = bool
  default     = false
}

variable "create_lambda_role" {
  description = "(Required) Create Lambda role"
  type        = bool
  default     = true
}

variable "user_extra_policy" {
  description = "(Optional) IAM User extra policy. This is a JSON formatted string."
  type        = string
  default     = null
}

variable "role_extra_policy" {
  description = "(Optional) Iam role extra policy. This is a JSON formatted string."
  type        = string
  default     = null
}

variable "lambda_extra_policy" {
  description = "(Optional) Lambda role extra policy. This is a JSON formatted string."
  type        = string
  default     = null
}

variable "ses_arn" {
  description = "(Optional)SES domain ARN, used to send emails."
  type        = string
  default     = null
}

variable "s3_bucket_name" {
  description = "(Required) S3 bucket name to store cloud-custodian logs."
  type        = string
}
