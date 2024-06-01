output "db_instance_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.default.endpoint
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.default.arn
}
