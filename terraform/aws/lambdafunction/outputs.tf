output "lambda_fuction_arn" {
  description = "Cluster Node Role"
  value       = aws_lambda_function.lambda_dynamodb_stream_handler.arn
}
