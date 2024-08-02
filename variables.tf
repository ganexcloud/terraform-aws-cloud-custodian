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

variable "role_trusted_role_arns" {
  description = "(Optional) Required if create_iam_role is true, ARNs of AWS entities who can assume these roles"
  type        = list(string)
  default     = []
}

variable "ses_arn" {
  description = "(Optional)SES domain ARN, used to send emails."
  type        = string
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Additional Tags"
  default     = {}
}

variable "s3_delete_objects_after" {
  description = "(Required) Retention period in days to store logs."
  default     = 365
  type        = number
}