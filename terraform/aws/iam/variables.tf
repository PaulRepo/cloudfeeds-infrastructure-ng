variable "datadog_aws_integration_external_id" {
  default = {
    test = "test_id"
    staging = "staging_id"
    production = "production_id"
  }
  description = ""
}

variable "table_arn" {
  description = "Arn of the cloudfeeds table resource for IAM policy control"
}

variable "bucket_arn" {
  description = "Arn of the cloudfeeds bucket resource for IAM policy control"
}
