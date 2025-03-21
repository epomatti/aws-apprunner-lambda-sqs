output "payments_local_queue_arn" {
  value = aws_sqs_queue.payments_local.arn
}

output "payments_deadletter_queue_arn" {
  value = aws_sqs_queue.payments_deadletter_local.arn
}
