# https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-creating-custom-policies-access-policy-examples.html#deny-not-from-vpc
# https://stackoverflow.com/questions/35432272/aws-lambda-unable-to-access-sqs-queue-from-a-lambda-function-with-vpc-access
# https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-configure-lambda-function-trigger.html
resource "aws_sqs_queue_policy" "vpce" {
  queue_url = var.sqs_queue_url

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "DenyNotFromVPCE",
    "Statement" : [
      {
        "Sid" : "1",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "${var.apprunner_instance_role_arn}"
          ]
        },
        "Action" : [
          "sqs:SendMessage",
          "sqs:ReceiveMessage"
        ],
        "Resource" : "${var.sqs_queue_arn}"
      },
      {
        "Sid" : "3",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "${var.lambda_execution_role_arn}"
          ]
        },
        "Action" : [
          "sqs:*"
        ],
        "Resource" : "${var.sqs_queue_arn}"
      },
      # {
      #   "Sid" : "2",
      #   "Effect" : "Deny",
      #   "Principal" : "*",
      #   "Action" : [
      #     "sqs:SendMessage",
      #     "sqs:ReceiveMessage"
      #   ],
      #   "Resource" : "${var.sqs_queue_arn}",
      #   "Condition" : {
      #     "StringNotEquals" : {
      #       "aws:sourceVpce" : "${var.vpce_sqs_id}"
      #     }
      #   }
      # }
    ]
    }
  )
}

resource "aws_secretsmanager_secret_policy" "secretsmanager_vpce" {
  secret_arn = var.secret_arn

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "DenySecretsManagerNotFromVPCE",
    "Statement" : [
      {
        "Sid" : "1",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "${var.apprunner_instance_role_arn}"
          ]
        },
        "Action" : [
          "secretsmanager:GetSecretValue"
        ],
        "Resource" : "${var.secret_arn}"
      },
      # {
      #   "Sid" : "2",
      #   "Effect" : "Deny",
      #   "Principal" : "*",
      #   "Action" : [
      #     "secretsmanager:GetSecretValue"
      #   ],
      #   "Resource" : "${var.secret_arn}",
      #   "Condition" : {
      #     "StringNotEquals" : {
      #       "aws:sourceVpce" : "${var.vpce_secretsmanager_id}"
      #     }
      #   }
      # }
    ]
    }
  )
}
