terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.49.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "items-01"
}

module "dynamodb" {
  source     = "./modules/dynamo"
  table_name = "cloud-exercise-table"
}

module "lambda" {
  source = "./modules/lambda"
}

module "api-gateway" {
  source                 = "./modules/api-gateway"
  get_items_lambda_arn   = module.lambda.get_items_lambda_arn
  save_items_lambda_arn  = module.lambda.save_items_lambda_arn
  get_items_lambda_name  = module.lambda.get_items_lambda_name
  save_items_lambda_name = module.lambda.save_items_lambda_name
  region                 = var.region
}
