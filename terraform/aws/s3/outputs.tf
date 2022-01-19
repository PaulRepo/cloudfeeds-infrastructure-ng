output "cloudfeeds_bucket_arn" {
  description = "The arn of the bucket."
  value       = aws_s3_bucket.cloudfeeds_bucket.arn
}

output "cloudfeeds_bucket_id" {
  description = "The id of the bucket."
  value       = aws_s3_bucket.cloudfeeds_bucket.id
}

output "cloudfeeds_bucket_all_tags" {
  value = aws_s3_bucket.cloudfeeds_bucket.tags_all
}
