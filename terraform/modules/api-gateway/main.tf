//create api gateway 
resource "aws_api_gateway_rest_api" "items_api" {
  name        = "items API"
  description = "API Gateway for items API"
}

resource "aws_api_gateway_resource" "items_resource" {
  rest_api_id = aws_api_gateway_rest_api.items_api.id
  parent_id   = aws_api_gateway_rest_api.items_api.root_resource_id
  path_part   = "items"
}

# Method for handling GET requests
resource "aws_api_gateway_method" "example_method" {
  rest_api_id   = aws_api_gateway_rest_api.items_api.id
  resource_id   = aws_api_gateway_resource.items_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "get_items_response" {
  rest_api_id = aws_api_gateway_rest_api.items_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_method.example_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# Method for handling OPTIONS requests for CORS
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.items_api.id
  resource_id   = aws_api_gateway_resource.items_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.items_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# Mock integration for OPTIONS requests
resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.items_api.id
  resource_id             = aws_api_gateway_resource.items_resource.id
  http_method             = aws_api_gateway_method.options_method.http_method
  type                    = "MOCK"
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.items_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_integration.options_integration.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_deployment" "items_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.post_lambda_integration,
    aws_api_gateway_integration.options_integration,
    aws_api_gateway_integration_response.items_integration,
    aws_api_gateway_integration_response.post_integration_response,
    aws_api_gateway_integration_response.options_integration_response
  ]

  rest_api_id = aws_api_gateway_rest_api.items_api.id
  stage_name  = "dev"
}


# Integration for GET requests
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.items_api.id
  resource_id             = aws_api_gateway_resource.items_resource.id
  http_method             = aws_api_gateway_method.example_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = var.get_items_lambda_arn//aws_lambda_function.get_items_lambda.invoke_arn
}

resource "aws_api_gateway_integration_response" "items_integration" {
  rest_api_id = aws_api_gateway_rest_api.items_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_integration.lambda_integration.http_method
  status_code = "200"
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}


resource "aws_lambda_permission" "allow_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.get_items_lambda_name//aws_lambda_function.get_items_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  // Ensure the source ARN is correct for your specific API Gateway deployment
  source_arn    = "${aws_api_gateway_rest_api.items_api.execution_arn}/*/*"
}


resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.items_api.id
  resource_id   = aws_api_gateway_resource.items_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "post_method_response" {
  rest_api_id = aws_api_gateway_rest_api.items_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# Integración para las solicitudes POST
resource "aws_api_gateway_integration" "post_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.items_api.id
  resource_id             = aws_api_gateway_resource.items_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = var.save_items_lambda_arn//aws_lambda_function.save_lambda.invoke_arn
}

resource "aws_api_gateway_integration_response" "post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.items_api.id
  resource_id = aws_api_gateway_resource.items_resource.id
  http_method = aws_api_gateway_integration.post_lambda_integration.http_method
  status_code = "200"
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_lambda_permission" "allow_gateway_post" {
  statement_id  = "AllowExecutionFromAPIGatewayPost"
  action        = "lambda:InvokeFunction"
  function_name = var.save_items_lambda_name//aws_lambda_function.save_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  // Asegúrate de que el ARN de origen es correcto para tu implementación específica de API Gateway
  source_arn    = "${aws_api_gateway_rest_api.items_api.execution_arn}/*/*/items"
}