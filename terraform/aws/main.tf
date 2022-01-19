provider "aws" {
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  token         = var.aws_session_token
  region        = var.region
  default_tags {
    tags = {
      Environment = var.active_environment
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
