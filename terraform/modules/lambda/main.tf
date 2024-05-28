data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.source_file
  output_path = "${path.module}/${var.zip_name}.zip"
}

resource "aws_lambda_function" "lambda" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = var.function_name
  role          = var.role
  handler       = var.handler
  runtime       = var.runtime
}

/*resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.source_arn
}*/