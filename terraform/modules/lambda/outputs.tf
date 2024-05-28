output "lambda_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.lambda.arn
}

output "lambda_invoke_arn" {
  description = "The invoke ARN of the Lambda function"
  value       = aws_lambda_function.lambda.invoke_arn
}