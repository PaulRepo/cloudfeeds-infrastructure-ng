/*resource "aws_dynamodb_table" "dynamodb_table_users" {
  name             = "UsersIds"
  billing_mode     = "PROVISIONED"
  read_capacity    = 5
  write_capacity   = 5
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  hash_key         = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-test-table"
    Environment = "dev"
  }
} */

resource "aws_lambda_function" "lambda_dynamodb_stream_handler" {
  function_name    = "process-usersids-records"
  filename         = "${data.archive_file.zip.output_path}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"
  handler          = "db_backup.lambda_handler"
  role             = var.cloudfeeds_lambdafunc_role
  runtime          = "python3.7"
  environment {
    variables = {
      BasketName = var.bucket_id
    }
  }
}

data "archive_file" "zip" {
    type        = "zip"
    source_file = "./lambdafunction/db_backup.py"
    output_path = "db_backup.zip"
  }
resource "aws_lambda_event_source_mapping" "lambda_dynamodb" {
  batch_size       = 1
  event_source_arn  = var.table_stream_arn
  function_name     = aws_lambda_function.lambda_dynamodb_stream_handler.arn
  starting_position = "LATEST"
}

