output "apprunner_service_url" {
  value = var.enable_app_runner ? module.apprunner[0].service_url : null
}
