# Iam User
resource "aws_iam_user" "this" {
  count         = var.create_iam_user ? 1 : 0
  name          = "cloud-custodian"
  path          = "/"
  force_destroy = false
}

resource "aws_iam_group" "this" {
  count = var.create_iam_user ? 1 : 0
  name  = "cloud-custodian"
  path  = "/"
}

resource "aws_iam_group_membership" "this" {
  count = var.create_iam_user ? 1 : 0
  name  = "cloud-custodian"
  users = [aws_iam_user.this[0].name]
  group = aws_iam_group.this[0].name
}

resource "aws_iam_access_key" "this" {
  count = var.create_iam_user ? 1 : 0
  user  = aws_iam_user.this[0].name
}

resource "aws_iam_policy" "user" {
  count  = var.create_iam_user ? 1 : 0
  name   = "cloud-custodian"
  policy = data.aws_iam_policy_document.iam_policy.json
}

resource "aws_iam_policy" "user_extra_policy" {
  count  = var.create_iam_user && var.user_extra_policy != null ? 1 : 0
  name   = "cloud-custodian-extra-policy"
  policy = var.user_extra_policy
  tags   = var.tags
}

resource "aws_iam_group_policy_attachment" "this" {
  count      = var.create_iam_user ? 1 : 0
  group      = aws_iam_group.this[0].name
  policy_arn = aws_iam_policy.user[0].arn
}

resource "aws_iam_group_policy_attachment" "user_extra_policy_attachment" {
  count      = var.create_iam_user && var.user_extra_policy != null ? 1 : 0
  group      = aws_iam_group.this[0].name
  policy_arn = aws_iam_policy.user_extra_policy[0].arn
}

# IAM Role
resource "aws_iam_role" "this" {
  count              = var.create_iam_role ? 1 : 0
  name               = "cloud-custodian"
  assume_role_policy = data.aws_iam_policy_document.iam_assume_role.json
}

resource "aws_iam_policy" "this" {
  count  = var.create_iam_role ? 1 : 0
  name   = "cloud-custodian"
  policy = data.aws_iam_policy_document.iam_policy.json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.create_iam_role ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_policy" "role_extra_policy" {
  count  = var.create_iam_role && var.role_extra_policy != null ? 1 : 0
  name   = "cloud-custodian-lambda-extra-policy"
  policy = var.role_extra_policy
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "role_extra_policy_attachment" {
  count      = var.create_iam_role && var.role_extra_policy != null ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.role_extra_policy[0].arn
}

# Lambda Role
resource "aws_iam_role" "lambda" {
  count              = var.create_lambda_role ? 1 : 0
  name               = "cloud-custodian-lambdaRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "lambda" {
  count  = var.create_lambda_role ? 1 : 0
  name   = "cloud-custodian-lambda-execution"
  policy = data.aws_iam_policy_document.lambda_policy.json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda" {
  count      = var.create_lambda_role ? 1 : 0
  role       = aws_iam_role.lambda[0].name
  policy_arn = aws_iam_policy.lambda[0].arn
}

resource "aws_iam_policy" "lambda_extra_policy" {
  count  = var.create_lambda_role && var.lambda_extra_policy != null ? 1 : 0
  name   = "cloud-custodian-lambda-extra-policy"
  policy = var.lambda_extra_policy
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_extra_policy_attachment" {
  count      = var.create_lambda_role && var.lambda_extra_policy != null ? 1 : 0
  role       = aws_iam_role.lambda[0].name
  policy_arn = aws_iam_policy.lambda_extra_policy[0].arn
}

# S3
resource "aws_s3_bucket" "this" {
  bucket = "${var.name}-${data.aws_region.current.name}"
  acl    = "private"
  tags   = var.tags
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# SQS
resource "aws_sqs_queue" "standard" {
  name = "cloud-custodian-notifications"
  tags = var.tags
}

resource "aws_sqs_queue" "dlq" {
  name = "cloud-custodian-notifications-dlq"
  tags = var.tags
}
