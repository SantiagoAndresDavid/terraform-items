variable "get_items_lambda_arn" {
  description = "ARN of the get items Lambda function"
  type        = string
}

variable "save_items_lambda_arn" {
  description = "ARN of the save items Lambda function"
  type        = string
}

variable "get_items_lambda_name" {
  description = "Name of the get items Lambda function"
  type        = string
}

variable "save_items_lambda_name" {
  description = "Name of the save items Lambda function"
  type        = string
}

variable "region" {
  description = "Name of region"
  type        = string
}
