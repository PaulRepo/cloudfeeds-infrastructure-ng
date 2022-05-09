provider "aws" {
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  token         = var.aws_session_token
  region        = var.region
  default_tags {
    tags = {
      Environment = var.environments[var.active_environment]
      Team        = "CloudFeeds"
    }
  }
}

module "s3_bucket" {
    source = "./s3"      
}

module "dynamodb" {
    source = "./dynamodb"      
}

module "iam_roles" {
    source = "./iam"
    aws_account_id = var.aws_account_id
    environment = var.environments[var.active_environment]
    table_arn = module.dynamodb.cloudfeeds_table_arn
    bucket_arn = module.s3_bucket.cloudfeeds_bucket_arn
}
