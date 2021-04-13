# Iam User
resource "aws_iam_user" "this" {
  count         = var.create_iam_user ? 1 : 0
  name          = var.name
  path          = "/"
  force_destroy = false
}

resource "aws_iam_access_key" "this" {
  count = var.create_iam_user ? 1 : 0
  user  = aws_iam_user.this[0].name
}

resource "aws_iam_user_policy" "this" {
  count  = var.create_iam_user ? 1 : 0
  name   = var.name
  user   = var.name
  policy = data.aws_iam_policy_document.iam_policy.json
}

resource "aws_iam_policy" "user_extra_policy" {
  count  = var.create_iam_user && var.user_extra_policy != null ? 1 : 0
  name   = "${var.name}-extra-policy"
  policy = var.user_extra_policy
}

resource "aws_iam_policy_attachment" "user_extra_policy_attachment" {
  count      = var.create_iam_user && var.user_extra_policy != null ? 1 : 0
  name       = "${var.name}-extra-policy"
  users      = ["${aws_iam_user.this[0].name}"]
  policy_arn = aws_iam_policy.user_extra_policy[0].arn
}

# IAM Role
resource "aws_iam_role" "this" {
  count              = var.create_iam_role ? 1 : 0
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.iam_assume_role.json
}

resource "aws_iam_policy" "this" {
  count  = var.create_iam_role ? 1 : 0
  name   = var.name
  policy = data.aws_iam_policy_document.iam_policy.json
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.create_iam_role ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_policy" "role_extra_policy" {
  count  = var.create_iam_role && var.role_extra_policy != null ? 1 : 0
  name   = "${var.name}-lambda-extra-policy"
  policy = var.role_extra_policy
}

resource "aws_iam_role_policy_attachment" "role_extra_policy_attachment" {
  count      = var.create_iam_role && var.role_extra_policy != null ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.role_extra_policy[0].arn
}

# Lambda Role
resource "aws_iam_role" "lambda" {
  count              = var.create_lambda_role ? 1 : 0
  name               = "${var.name}-${data.aws_region.current.name}-lambdaRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "lambda" {
  count  = var.create_lambda_role ? 1 : 0
  name   = "${var.name}-lambda-execution"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  count      = var.create_lambda_role ? 1 : 0
  role       = aws_iam_role.lambda[0].name
  policy_arn = aws_iam_policy.lambda[0].arn
}

resource "aws_iam_policy" "lambda_extra_policy" {
  count  = var.create_lambda_role && var.lambda_extra_policy != null ? 1 : 0
  name   = "${var.name}-lambda-extra-policy"
  policy = var.lambda_extra_policy
}

resource "aws_iam_role_policy_attachment" "lambda_extra_policy_attachment" {
  count      = var.create_lambda_role && var.lambda_extra_policy != null ? 1 : 0
  role       = aws_iam_role.lambda[0].name
  policy_arn = aws_iam_policy.lambda_extra_policy[0].arn
}

# S3
resource "aws_s3_bucket" "this" {
  bucket = var.s3_bucket_name
  acl    = "private"
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
  name = "${var.name}-notifications"
}

resource "aws_sqs_queue" "dlq" {
  name = "${var.name}-notifications-dlq"
}
