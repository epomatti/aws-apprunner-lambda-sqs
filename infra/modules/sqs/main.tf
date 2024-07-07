# Reference:
# https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html

resource "aws_sqs_queue" "payments" {
  name                    = "${var.workload}-payments"
  sqs_managed_sse_enabled = true

  # TODO: Implement this
  # delay_seconds             = 90
  # max_message_size          = 2048
  # message_retention_seconds = 86400
  # receive_wait_time_seconds = 10
}

resource "aws_sqs_queue" "payments_deadletter" {
  name                    = "${var.workload}-payments-dlq"
  sqs_managed_sse_enabled = true
}

resource "aws_sqs_queue_redrive_policy" "payments" {
  queue_url = aws_sqs_queue.payments.id

  redrive_policy = jsonencode({
    deadLetterTargetArn = "${aws_sqs_queue.payments_deadletter.arn}",
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue_redrive_allow_policy" "payments" {
  queue_url = aws_sqs_queue.payments.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = ["${aws_sqs_queue.payments.arn}"]
  })
}
