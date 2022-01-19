output "cloudfeeds_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.cloudfeeds_table.arn
}

output "cloudfeeds_table_id" {
  description = "ID of the DynamoDB table"
  value       = aws_dynamodb_table.cloudfeeds_table.id
}

output "cloudfeeds_table_all_tags" {
  value = aws_dynamodb_table.cloudfeeds_table.tags_all
}
