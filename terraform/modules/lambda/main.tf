data "archive_file" "save_items" {
  type        = "zip"
  source_file = "/home/santiago/Documents/workspace/terraform-exercise/backend/save_items.py"
  output_path = "${path.module}/save_items.zip"
}

resource "aws_lambda_function" "save_items_lambda" {
  filename         = data.archive_file.save_items.output_path
  function_name    = "save-items-lambda"
  role             = "arn:aws:iam::381491975644:role/service-role/test-lambda-role"
  handler          = "save_items.handle"
  runtime          = "python3.12"
}

data "archive_file" "get_items" {
  type        = "zip"
  source_file = "/home/santiago/Documents/workspace/terraform-exercise/backend/get_items_db.py"
  output_path = "${path.module}/get_items.zip"
}


resource "aws_lambda_function" "get_items_lambda" {
  filename         = data.archive_file.get_items.output_path
  function_name    = "get-items-lambda"
  role             = "arn:aws:iam::381491975644:role/service-role/test-lambda-role"
  handler          = "get_items_db.handle"
  runtime          = "python3.12"
}
