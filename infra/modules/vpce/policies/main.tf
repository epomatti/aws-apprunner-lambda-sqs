# https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-creating-custom-policies-access-policy-examples.html#deny-not-from-vpc
resource "aws_sqs_queue_policy" "vpce" {
  queue_url = var.sqs_queue_url

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "DenyNotFromVPCE",
    "Statement" : [{
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
        "Sid" : "2",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : [
          "sqs:SendMessage",
          "sqs:ReceiveMessage"
        ],
        "Resource" : "${var.sqs_queue_arn}",
        "Condition" : {
          "StringNotEquals" : {
            "aws:sourceVpce" : "${var.vpce_sqs_id}"
          }
        }
      }
    ]
    }
  )
}
