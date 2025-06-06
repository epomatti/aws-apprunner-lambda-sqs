data "aws_caller_identity" "current" {}

locals {
  current_account_id = data.aws_caller_identity.current.account_id
  vpc_actions = [
    "ec2:CreateNetworkInterface",
    "ec2:DescribeNetworkInterfaces",
    "ec2:DescribeSubnets",
    "ec2:DeleteNetworkInterface",
    "ec2:AssignPrivateIpAddresses",
    "ec2:UnassignPrivateIpAddresses",
    "ec2:DetachNetworkInterface",
    "ec2:DescribeSecurityGroups",
    "ec2:DescribeVpcs",
    "ec2:getSecurityGroupsForVpc"
  ]
}

resource "aws_iam_role" "lambda" {
  name = "${var.workload}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "default" {
  name = "apprunner-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "LambdaVPCInjection"
        "Effect" : "Allow",
        "Action" : "${local.vpc_actions}",
        "Resource" : ["*"]
      },
      {
        "Sid" : "LeastPrivilegeLambdaDeny"
        "Effect" : "Deny",
        "Action" : "${local.vpc_actions}",
        "Resource" : ["*"],
        "Condition" : {
          "ArnEquals" : {
            "lambda:SourceFunctionArn" : [
              "arn:aws:lambda:${var.aws_region}:${local.current_account_id}:function:${var.function_name}"
            ]
          }
        }
      },
      {
        Sid    = "SSMLambdaExtension"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "kms:Decrypt",
          "secretsmanager:GetSecretValue",
        ]
        Resource = [
          "*",
        ]
      },
      {
        Sid    = "LambdaDynamoDB"
        Effect = "Allow"
        Action = [
          "dynamodb:BatchGet*",
          "dynamodb:DescribeStream",
          "dynamodb:DescribeTable",
          "dynamodb:Get*",
          "dynamodb:ListTables",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWrite*",
          "dynamodb:Delete*",
          "dynamodb:Update*",
          "dynamodb:PutItem",
        ]
        Resource = [
          "*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.default.arn
}

resource "aws_iam_role_policy_attachment" "AmazonS3FullAccess" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonSQSFullAccess" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
