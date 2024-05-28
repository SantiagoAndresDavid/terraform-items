variable "source_file" {
  description = "Path to the Lambda function source file"
  type        = string
}


variable "zip_name" {
  description = "Name of the zip"
  type        = string
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "role" {
  description = "IAM role for the Lambda function"
  type        = string
}

variable "handler" {
  description = "Handler for the Lambda function"
  type        = string
}

variable "runtime" {
  description = "Runtime for the Lambda function"
  type        = string
}

/*variable "source_arn" {
  description = "Source ARN for Lambda permission"
  type        = string
}*/
