# Iam User
resource "aws_iam_user" "this" {
  name          = var.name
  path          = "/"
  force_destroy = false
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_iam_user_policy" "this" {
  name   = var.name
  user   = var.name
  policy = data.aws_iam_policy_document.iam_policy.json
}

data "aws_iam_policy_document" "iam_policy" {
  statement {
    actions = [
      "cloudwatch:PutMetricData",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeRegions",
      "events:PutRule",
      "events:PutTargets",
      "events:DescribeRule",
      "events:ListTargetsByRule",
      "iam:PassRole",
      "lambda:GetFunction",
      "lambda:CreateFunction",
      "lambda:TagResource",
      "lambda:CreateEventSourceMapping",
      "lambda:UntagResource",
      "lambda:PutFunctionConcurrency",
      "lambda:DeleteFunction",
      "lambda:UpdateEventSourceMapping",
      "lambda:InvokeFunction",
      "lambda:UpdateFunctionConfiguration",
      "lambda:UpdateAlias",
      "lambda:UpdateFunctionCode",
      "lambda:AddPermission",
      "lambda:DeleteAlias",
      "lambda:DeleteFunctionConcurrency",
      "lambda:DeleteEventSourceMapping",
      "lambda:RemovePermission",
      "lambda:CreateAlias",
      "lambda:ListFunctions",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}",
      "${aws_s3_bucket.this.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "iam_extra_policy" {
  count  = var.iam_extra_policy != null ? 1 : 0
  name   = "${var.name}-iam-extra-policy"
  policy = var.iam_extra_policy
}

resource "aws_iam_policy_attachment" "iam_extra_policy_attachment" {
  count      = var.iam_extra_policy != null ? 1 : 0
  name       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.iam_extra_policy[0].arn
}

# Lambda Role
resource "aws_iam_role" "lambda" {
  name               = "${var.name}-${data.aws_region.current.name}-lambdaRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "health:DescribeEvents",
      "health:DescribeAffectedEntities",
      "health:DescribeEventDetails",
      "lambda:DeleteFunction",
      "lambda:GetPolicy",
      "lambda:RemovePermission",
      "lambda:TagResource",
      "lambda:UntagResource",
      "lambda:InvokeFunction",
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetEventSelectors",
      "cloudtrail:GetTrailStatus",
      "config:DescribeDeliveryChannels",
      "config:DescribeConfigurationRecorders",
      "config:DescribeConfigurationRecorderStatus",
      "config:GetResourceConfigHistory",
      "support:DescribeTrustedAdvisorCheckResult",
      "support:RefreshTrustedAdvisorCheck",
      "shield:DescribeSubscription",
      "shield:DeleteSubscription",
      "ec2:AssociateIamInstanceProfile",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CopySnapshot",
      "ec2:CreateSnapshot",
      "ec2:Describe*",
      "tag:TagResources",
      "tag:UntagResources",
      "waf-regional:AssociateWebACL",
      "waf-regional:ListResourcesForWebACL",
      "waf-regional:ListWebACLs",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancerPolicies",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
      "autoscaling:CreateOrUpdateTags",
      "autoscaling:DeleteTags",
      "autoscaling:SuspendProcesses",
      "autoscaling:ResumeProcesses",
      "autoscaling:Describe*",
      "cloudfront:GetDistributionConfig",
      "cloudfront:GetStreamingDistributionConfig",
      "cloudfront:UpdateStreamingDistribution",
      "waf:ListWebACLs",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetMetricStatistics",
      "cloudWatch:PutMetricData",
      "logs:DeleteLogGroup",
      "logs:DescribeLogStreams",
      "logs:PutRetentionPolicy",
      "logs:DescribeLogGroups",
      "ecr:GetRepositoryPolicy",
      "ecr:SetRepositoryPolicy",
      "elasticfilesystem:DescribeMountTargets",
      "sqs:GetQueueAttributes",
      "sqs:SetQueueAttributes",
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",
      "rds:AddTagsToResource",
      "rds:CopyDBSnapshot",
      "rds:CreateDBSnapshot",
      "rds:DeleteDBInstance",
      "rds:DeleteDBSnapshot",
      "rds:DescribeDBEngineVersions",
      "rds:DescribeDBInstances",
      "rds:DescribeDBParameters",
      "rds:DescribeDBSnapshotAttributes",
      "rds:DescribeDBSnapshots",
      "rds:RemoveTagsFromResource",
      "iam:GenerateCredentialReport",
      "iam:GetAccountSummary",
      "iam:GetAccountPasswordPolicy",
      "iam:GetCredentialReport",
      "iam:GetGroup",
      "iam:ListAccessKeys",
      "iam:ListAccountAliases",
      "iam:ListAttachedUserPolicies",
      "iam:ListAttachedRolePolicies",
      "iam:ListPolicyVersions",
      "iam:ListGroupPolicies",
      "iam:ListGroupsForUser",
      "iam:ListMfaDevices",
      "iam:ListPolicies",
      "iam:ListRolePolicies",
      "iam:ListVirtualMFADevices",
      "iam:UpdateAccessKey",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:GetBucketPolicy",
      "s3:GetObject",
      "s3:GetBucketNotification",
      "s3:GetBucketPolicy",
      "s3:GetInventoryConfiguration",
      "s3:PutBucketAcl",
      "s3:PutBucketPolicy",
      "s3:PutBucketVersioning",
      "s3:PutBucketLogging",
      "s3:PutBucketNotification",
      "s3:PutInventoryConfiguration",
      "s3:PutObject",
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetEventSelectors",
      "securityhub:BatchImportFindings",
      "events:ListRules",
      "tag:GetResources",
      "lambda:ListFunctions"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/custodian-*",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.name}/"
    ]
  }
  statement {
    actions = [
      "logs:CreateLogStream",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/custodian-*:*",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.name}/*:*"
    ]
  }

  statement {
    actions = [
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/custodian-*:*:*",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.name}/*:*:*"
    ]
  }

  statement {
    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ListDeadLetterSourceQueues",
      "sqs:ListQueues",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:SendMessage"
    ]

    resources = [
      aws_sqs_queue.standard.arn,
      aws_sqs_queue.dlq.arn
    ]
  }

  statement {
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]

    resources = [
      var.ses_arn
    ]
  }
}

resource "aws_iam_policy" "lambda" {
  name   = "${var.name}-lambda-execution"
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}

resource "aws_iam_policy" "lambda_extra_policy" {
  count  = var.lambda_extra_policy != null ? 1 : 0
  name   = "${var.name}-lambda-extra-policy"
  policy = var.lambda_extra_policy
}

resource "aws_iam_role_policy_attachment" "lambda_extra_policy_attachment" {
  count      = var.lambda_extra_policy != null ? 1 : 0
  role       = aws_iam_role.lambda.name
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
