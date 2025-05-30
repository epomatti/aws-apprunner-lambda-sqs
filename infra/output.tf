output "apprunner_service_url" {
  value = var.enable_app_runner ? "https://${module.apprunner[0].service_url}" : null
}

output "sqs_queue_local" {
  value = module.sqs_local.payments_local_queue_arn
}

output "sqs_queue_deadletter" {
  value = module.sqs_local.payments_deadletter_queue_arn
}

output "local_lambda_secret_arn" {
  value = module.secrets.local_lambda_secret_arn
}

output "local_lambda_secret_name" {
  value = module.secrets.local_lambda_secret_name
}

output "bucket_lambda" {
  value = module.bucket_lambda.bucket_lambda
}
