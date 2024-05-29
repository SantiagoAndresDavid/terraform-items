output "get_items_lambda_arn" {
  value = aws_lambda_function.get_items_lambda.invoke_arn
}

output "save_items_lambda_arn" {
  value = aws_lambda_function.save_items_lambda.invoke_arn
}

output "get_items_lambda_name" {
  value = aws_lambda_function.get_items_lambda.function_name
}

output "save_items_lambda_name" {
  value = aws_lambda_function.save_items_lambda.function_name
}
