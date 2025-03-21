output "apprunner_service_url" {
  value = var.enable_app_runner ? module.apprunner[0].service_url : null
}

output "sqs_queue_local" {
  value = module.sqs_local.payments_local_queue_arn
}

output "sqs_queue_deadletter" {
  value = module.sqs_local.payments_deadletter_queue_arn
}
