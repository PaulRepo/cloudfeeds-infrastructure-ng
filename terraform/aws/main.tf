provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  #token         = var.aws_session_token
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.environments[var.active_environment]
      Team        = "CloudFeeds"
    }
  }
}

locals {
  name_prefix = "${var.project_name}-${var.environments[var.active_environment]}"
}

locals {
  cluster_name = "${local.name_prefix}-cluster"
}

data "aws_availability_zones" "available" {}

module "s3_bucket" {
  source = "./s3"
}

module "dynamodb" {
  source = "./dynamodb"
}

module "lambdafunction" {
  source                     = "./lambdafunction"
  table_stream_arn           = module.dynamodb.cloudfeeds_table_stream_arn
  bucket_id                  = module.s3_bucket.cloudfeeds_bucket_id
  cloudfeeds_lambdafunc_role = module.iam_roles.cloudfeeds_lambdafunc_role
}


module "iam_roles" {
  source = "./iam"
  #aws_account_id = var.aws_account_id
  #environment = var.environments[var.active_environment]
  table_arn          = module.dynamodb.cloudfeeds_table_arn
  bucket_arn         = module.s3_bucket.cloudfeeds_bucket_arn
  lambda_fuction_arn = module.lambdafunction.lambda_fuction_arn
}
