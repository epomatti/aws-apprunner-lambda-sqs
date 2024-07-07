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

module "iam" {
  source = "./modules/iam"
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
  instance_role_arn = module.iam.instance_role_arn
  access_role_arn   = module.iam.access_role_arn

  depends_on = [module.iam]
}
