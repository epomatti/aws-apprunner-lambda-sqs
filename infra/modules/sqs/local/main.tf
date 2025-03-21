resource "aws_sqs_queue" "payments_local" {
  name                       = "${var.workload}-payments-local"
  sqs_managed_sse_enabled    = true
  visibility_timeout_seconds = 120
}

resource "aws_sqs_queue" "payments_deadletter_local" {
  name                    = "${var.workload}-payments-local-dlq"
  sqs_managed_sse_enabled = true
}

resource "aws_sqs_queue_redrive_policy" "payments_local" {
  queue_url = aws_sqs_queue.payments_local.id

  redrive_policy = jsonencode({
    deadLetterTargetArn = "${aws_sqs_queue.payments_deadletter_local.arn}",
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue_redrive_allow_policy" "payments_local" {
  queue_url = aws_sqs_queue.payments_local.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = ["${aws_sqs_queue.payments_local.arn}"]
  })
}
