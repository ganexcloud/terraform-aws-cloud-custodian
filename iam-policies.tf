# Iam User/Role
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
      "events:DeleteRule",
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
      "events:RemoveTargets",
      "lambda:UpdateFunctionCode",
      "lambda:AddPermission",
      "lambda:DeleteEventSourceMapping",
      "lambda:CreateAlias",
      "lambda:ListFunctions",
      "lambda:GetPolicy",
      "lambda:GetFunctionConfiguration",
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
      "arn:aws:s3:::${var.name}*",
      "arn:aws:s3:::${var.name}*/*"
    ]
  }

  dynamic "statement" {
    for_each = var.ses_arn != null ? list(1) : []

    content {
      actions = [
        "ses:SendEmail",
        "ses:SendRawEmail"
      ]
      resources = [
        var.ses_arn
      ]
    }
  }
}

# Iam Role
data "aws_iam_policy_document" "iam_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = var.role_trusted_role_arns
    }
  }
}

# Lambda role
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:custodian-*", "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:cloud-custodian-mailer"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    actions = [
      "health:DescribeEvents",
      "health:DescribeAffectedEntities",
      "health:DescribeEventDetails",
      "lambda:GetPolicy",
      "lambda:RemovePermission",
      "lambda:TagResource",
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
      "ec2:CreateTags",
      "ec2:Describe*",
      "elasticfilesystem:Describe*",
      "tag:TagResources",
      "waf-regional:ListResourcesForWebACL",
      "waf-regional:ListWebACLs",
      "elasticloadbalancing:Describe*",
      "autoscaling:CreateOrUpdateTags",
      "autoscaling:SuspendProcesses",
      "autoscaling:ResumeProcesses",
      "autoscaling:Describe*",
      "cloudfront:Get*",
      "cloudfront:Describe*",
      "cloudfront:ListDistributions",
      "waf:ListWebACLs",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetMetricStatistics",
      "cloudWatch:PutMetricData",
      "logs:DescribeLogStreams",
      "logs:PutRetentionPolicy",
      "logs:DescribeLogGroups",
      "logs:TagLogGroup",
      "logs:ListTagsLogGroup",
      "logs:TagResource",
      "logs:ListTagsForResource",
      "ecr:GetRepositoryPolicy",
      "elasticfilesystem:DescribeMountTargets",
      "sqs:GetQueueAttributes",
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",
      "rds:AddTagsToResource",
      "rds:DescribeDBEngineVersions",
      "rds:DescribeDBInstances",
      "rds:DescribeDBParameters",
      "rds:DescribeDBSnapshotAttributes",
      "rds:DescribeDBSnapshots",
      "rds:DescribeReservedDBInstances",
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
      "s3:List*",
      "s3:Get*",
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetEventSelectors",
      "securityhub:BatchImportFindings",
      "events:ListRules",
      "tag:GetResources",
      "lambda:ListFunctions",
      "dynamodb:List*",
      "dynamodb:Describe*",
      "kms:List*",
      "kms:Describe*",
      "route53:List*",
      "route53:Get*",
      "elasticache:List*",
      "elasticache:Describe*",
      "ecr:List*",
      "ecr:Describe*",
      "ssm:DescribeParameters",
      "events:ListTagsForResource",
      "events:TagResource",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
    ]

    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/custodian-*",
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/cloud-custodian-mailer",
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:cloud-custodian*"
    ]
  }
  statement {
    actions = [
      "logs:CreateLogStream",
    ]

    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/custodian-*",
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/cloud-custodian-mailer",
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:cloud-custodian*"
    ]
  }

  statement {
    actions = [
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/custodian-*:*:*",
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/cloud-custodian-mailer:*:*",
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:cloud-custodian*:*:*"
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
      "arn:aws:sqs:*:${data.aws_caller_identity.current.account_id}:${aws_sqs_queue.standard.name}",
      "arn:aws:sqs:*:${data.aws_caller_identity.current.account_id}:${aws_sqs_queue.dlq.name}"
    ]
  }

  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${var.name}*",
      "arn:aws:s3:::${var.name}*/*"
    ]
  }

  dynamic "statement" {
    for_each = var.ses_arn != null ? list(1) : []

    content {
      actions = [
        "ses:SendEmail",
        "ses:SendRawEmail"
      ]
      resources = [
        var.ses_arn
      ]
    }
  }
}
