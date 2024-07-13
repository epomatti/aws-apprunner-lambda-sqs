### Instance Role ###
resource "aws_iam_role" "instance_role" {
  name = "AppRunnerInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tasks_sqs_full_access" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

### Access Role ###
resource "aws_iam_role" "access_role" {
  name = "AppRunnerAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.access_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.access_role.name
  policy_arn = aws_iam_policy.default.arn
}

resource "aws_iam_policy" "default" {
  name = "apprunner-secrets-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SSMAppRunnerExtension"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "kms:Decrypt"
        ]
        Resource = [
          "*",
        ]
      }
    ]
  })
}
