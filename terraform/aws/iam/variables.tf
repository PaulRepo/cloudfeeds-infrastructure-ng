variable "datadog_aws_integration_external_id" {
  default = {
    test = "test_id"
    staging = "staging_id"
    production = "production_id"
  }
  description = ""
}

#variable "aws_account_id" {
#  description = "AWS account id for datadog integration configuration"
#}

#variable "environment" {
#  description = "The current active environment"
#}

variable "table_arn" {
  description = "Arn of the cloudfeeds table resource for IAM policy control"
}

variable "bucket_arn" {
  description = "Arn of the cloudfeeds bucket resource for IAM policy control"
}

variable "lambda_fuction_arn" {
  description = "Arn of the backup lambda function"
}
