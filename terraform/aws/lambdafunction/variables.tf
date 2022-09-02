variable "table_stream_arn" {
  description = "Arn of the cloudfeeds table resource for IAM policy control"
}

variable "bucket_id" {
  description = "Cloudfeeds Bucket Name"
}

variable "cloudfeeds_lambdafunc_role" {
  description = "IAM role ARN"
}