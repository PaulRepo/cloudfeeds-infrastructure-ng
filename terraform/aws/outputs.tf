output "cf_bucket_arn" {
  description = "arn of the bucket."
  value       = module.s3_bucket.cloudfeeds_bucket_arn
}

output "cf_bucket_id" {
  description = "id of the bucket."
  value       = module.s3_bucket.cloudfeeds_bucket_id
}

output "cf_table_id" {
  description = "id of the dynamodb table"
  value       = module.dynamodb.cloudfeeds_table_id
}

output "cf_table_arn" {
  description = "arn of the dynamodb table"
  value       = module.dynamodb.cloudfeeds_table_arn
}

output "cf_bucket_all_tags" {
  value = module.s3_bucket.cloudfeeds_bucket_all_tags
}

output "cf_table_all_tags" {
  value = module.dynamodb.cloudfeeds_table_all_tags
}
