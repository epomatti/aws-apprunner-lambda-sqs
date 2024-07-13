terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.57.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source     = "./modules/vpc"
  aws_region = var.aws_region
  workload   = var.workload
}

module "ecr" {
  source = "./modules/ecr"
}

module "sqs" {
  source   = "./modules/sqs"
  workload = var.workload
}

module "ssm" {
  source          = "./modules/ssm"
  workload        = var.workload
  lambda_username = var.lambda_username
  lambda_password = var.lambda_password
}

module "iam_apprunner" {
  source = "./modules/iam/apprunner"
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

  ssm_lambda_username_secret_arn = module.ssm.lambda_username_secret_arn
  ssm_lambda_password_secret_arn = module.ssm.lambda_password_secret_arn

  depends_on = [module.iam_apprunner]
}

module "iam_lambda" {
  source   = "./modules/iam/lambda"
  workload = var.workload
}

module "lambda" {
  count                 = var.enable_app_runner ? 1 : 0
  source                = "./modules/lambda"
  name                  = var.workload
  execution_role_arn    = module.iam_lambda.execution_role_arn
  sqs_queue_arn         = module.sqs.payments_queue_arn
  memory_size           = var.lambda_memory_size
  timeout               = var.lambda_timeout
  sqs_trigger_enabled   = var.lambda_sqs_trigger_enabled
  apprunner_service_url = module.apprunner[0].service_url

  ssm_lambda_username_parameter_name = module.ssm.lambda_username_parameter_name
  ssm_lambda_password_parameter_name = module.ssm.lambda_password_parameter_name

  depends_on = [module.iam_lambda, module.apprunner]
}
