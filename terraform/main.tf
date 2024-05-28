terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.49.0"
    }
  }

  required_version = ">= 1.2.0"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "items-01"
}

module "dynamodb" {
  source     = "./modules/dynamo"
  table_name = "cloud-exercise-table"
}


/*module "get-items-lambda" {
  source = "./modules/lambda"  
}*/

module "get_items_lambda" {
  source        = "./modules/lambda"
  source_file   = "/home/santiago/Documents/workspace/terraform-items/backend/get_items_db.py"
  function_name = "get-items-lambda"
  role          = "arn:aws:iam::381491975644:role/service-role/test-lambda-role"
  handler       = "get_items_db.handle"
  runtime       = "python3.12"
  zip_name = "get-items"
  //source_arn    = "${module.api_gateway.api_id}/*/*"
}


module "save_items_lambda" {
  source        = "./modules/lambda"
  source_file   = "/home/santiago/Documents/workspace/terraform-exercise/backend/save_items.py"
  function_name = "save-items-lambda"
  role          = "arn:aws:iam::381491975644:role/service-role/test-lambda-role"
  handler       = "save_items.handle"
  runtime       = "python3.12"
  zip_name = "save-items"
  //source_arn    = "${module.api_gateway.api_id}/*/*/items"
}
