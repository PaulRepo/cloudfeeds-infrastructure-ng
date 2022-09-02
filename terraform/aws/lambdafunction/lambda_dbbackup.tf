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

