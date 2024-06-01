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

/*module "rds" {
  source                = "./modules/rds"
  allocated_storage     = 20
  max_allocated_storage = 20
  engine                = "mysql"
  engine_version        = "8.0.35"  # Cambiado a una versión compatible
  instance_class        = "db.t3.micro"
  db_name               = "mydatabase"
  username              = "admin"
  password              = "your-secure-password"
  parameter_group_name  = "default.mysql5.7"
  skip_final_snapshot   = true
  publicly_accessible   = true
  tags = {
    Name = "MyDatabaseInstance"
  }
}*/