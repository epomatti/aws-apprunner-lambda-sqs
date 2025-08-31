terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

locals {
  lambda_function_name = ""
}

module "vpc" {
  source             = "./modules/vpc"
  aws_region         = var.aws_region
  workload           = var.workload
  create_nat_gateway = var.create_nat_gateway
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
}

module "ecr" {
  source   = "./modules/ecr"
  workload = var.workload
}

module "sqs_cloud" {
  source                     = "./modules/sqs/cloud"
  workload                   = var.workload
  visibility_timeout_seconds = var.lambda_sqs_visibility_timeout_seconds
}

module "sqs_local" {
  source   = "./modules/sqs/local"
  workload = var.workload
}

module "secrets" {
  source          = "./modules/secrets"
  workload        = var.workload
  lambda_password = var.lambda_password
}

module "iam_apprunner" {
  source            = "./modules/iam/apprunner"
  lambda_secret_arn = module.secrets.lambda_secret_arn
}

module "ssm" {
  source          = "./modules/ssm"
  workload        = var.workload
  lambda_username = var.lambda_username
  lambda_password = var.lambda_password
}

module "apprunner" {
  count             = var.enable_app_runner ? 1 : 0
  source            = "./modules/apprunner"
  workload          = var.workload
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  cpu               = var.app_runner_cpu
  memory            = var.app_runner_memory
  repository_url    = module.ecr.repository_url
  image_tag         = var.ecr_image_tag
  instance_role_arn = module.iam_apprunner.instance_role_arn
  access_role_arn   = module.iam_apprunner.access_role_arn

  sqs_queue_url                  = module.sqs_cloud.payments_queue_url
  ssm_lambda_username_secret_arn = module.ssm.lambda_username_secret_arn
  ssm_lambda_password_secret_arn = module.ssm.lambda_password_secret_arn

  depends_on = [module.iam_apprunner]
}

module "dynamodb" {
  source               = "./modules/dynamodb"
  workload             = var.workload
  vpc_id               = module.vpc.vpc_id
  private_route_tables = []
  aws_region           = var.aws_region
}

module "iam_lambda" {
  source        = "./modules/iam/lambda"
  workload      = var.workload
  function_name = var.workload
  aws_region    = var.aws_region
}

module "lambda" {
  count                        = var.enable_app_runner ? 1 : 0
  source                       = "./modules/lambda"
  name                         = var.workload
  execution_role_arn           = module.iam_lambda.execution_role_arn
  lambda_handler_zip           = var.lambda_handler_zip
  lambda_architectures         = var.lambda_architectures
  lambda_runtime               = var.lambda_runtime
  lambda_handler               = var.lambda_handler
  sqs_queue_arn                = module.sqs_cloud.payments_queue_arn
  memory_size                  = var.lambda_memory_size
  timeout                      = var.lambda_timeout
  sqs_trigger_enabled          = var.lambda_sqs_trigger_enabled
  apprunner_service_url        = module.apprunner[0].service_url
  apprunner_username           = var.lambda_username
  lambda_snap_start            = var.lambda_snap_start
  lambda_secret_name           = module.secrets.lambda_secret_name
  lambda_sqs_batch_size        = var.lambda_sqs_batch_size
  maximum_concurrency          = var.lambda_sqs_maximum_concurrency
  vpc_id                       = module.vpc.vpc_id
  private_subnets              = module.vpc.private_subnets
  lambda_log_format            = var.lambda_log_format
  lambda_log_group_name        = module.cloudwatch.lambda_name
  lambda_application_log_level = var.lambda_application_log_level
  lambda_system_log_level      = var.lambda_system_log_level

  depends_on = [module.iam_lambda, module.apprunner]
}

module "bucket_lambda" {
  source   = "./modules/s3"
  workload = var.workload
}

module "vpce_sqs" {
  source                      = "./modules/vpce/sqs"
  affix                       = "sqs"
  aws_region                  = var.aws_region
  vpc_id                      = module.vpc.vpc_id
  subnet_id                   = module.vpc.vpce_subnet
  apprunner_instance_role_arn = module.iam_apprunner.instance_role_arn
  lambda_execution_role_arn   = module.iam_lambda.execution_role_arn
  sqs_queue_arn               = module.sqs_cloud.payments_queue_arn
}

module "vpce_secretsmanager" {
  source                      = "./modules/vpce/secrets"
  affix                       = "secretsmanager"
  aws_region                  = var.aws_region
  vpc_id                      = module.vpc.vpc_id
  subnet_id                   = module.vpc.vpce_subnet
  apprunner_instance_role_arn = module.iam_apprunner.instance_role_arn
  lambda_secret_arn           = module.secrets.lambda_secret_arn
}

module "vpce_policies" {
  source                      = "./modules/vpce/policies"
  sqs_queue_url               = module.sqs_cloud.payments_queue_url
  apprunner_instance_role_arn = module.iam_apprunner.instance_role_arn
  lambda_execution_role_arn   = module.iam_lambda.execution_role_arn
  sqs_queue_arn               = module.sqs_cloud.payments_queue_arn
  vpce_sqs_id                 = module.vpce_sqs.vpce_sqs_id
  secret_arn                  = module.secrets.lambda_secret_arn
  vpce_secretsmanager_id      = module.vpce_secretsmanager.vpce_secretsmanager_id
}

module "ec2_jumpserver" {
  count         = var.create_jumpserver ? 1 : 0
  source        = "./modules/ec2-jumpserver"
  workload      = var.workload
  subnet        = module.vpc.private_subnets[0]
  vpc_id        = module.vpc.vpc_id
  ami           = var.ec2_jumpserver_ami
  instance_type = var.ec2_jumpserver_instance_type

  depends_on = [module.vpc]
}
