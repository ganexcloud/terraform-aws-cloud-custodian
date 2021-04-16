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
      "lambda:DeleteAlias",
      "lambda:DeleteFunctionConcurrency",
      "lambda:DeleteEventSourceMapping",
      "lambda:RemovePermission",
      "lambda:CreateAlias",
      "lambda:ListFunctions",
      "lambda:GetPolicy",
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
      "elasticfilesystem:Describe*",
      "tag:TagResources",
      "tag:UntagResources",
      "waf-regional:AssociateWebACL",
      "waf-regional:ListResourcesForWebACL",
      "waf-regional:ListWebACLs",
      "elasticloadbalancing:Describe*",
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
      "logs:TagLogGroup",
      "logs:UntagLogGroup",
      "logs:ListTagsLogGroup",
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
      "route53:Get*"
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
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}",
      "${aws_s3_bucket.this.arn}/*"
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
