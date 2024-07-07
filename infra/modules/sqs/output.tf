output "payments_queue_arn" {
  value = aws_sqs_queue.payments.arn
}

output "payments_queue_name" {
  value = aws_sqs_queue.payments.name
}
