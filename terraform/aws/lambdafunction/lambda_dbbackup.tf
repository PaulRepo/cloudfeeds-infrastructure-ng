provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_dynamodb_table" "dynamodb_table_users" {
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
}

resource "aws_lambda_function" "lambda_dynamodb_stream_handler" {
  function_name    = "process-usersids-records"
  filename         = "${data.archive_file.zip.output_path}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"
  handler          = "db_backup.lambda_handler"
  role             = aws_iam_role.iam_for_lambda.arn
  runtime          = "python3.6"
  environment {
    variables = {
      BasketName = "newbucket-kkrackspace18"
    }
  }
}

data "archive_file" "zip" {
    type        = "zip"
    source_file = "db_backup.py"
    output_path = "db_backup.zip"
  }
resource "aws_lambda_event_source_mapping" "lambda_dynamodb" {
  event_source_arn  = aws_dynamodb_table.dynamodb_table_users.stream_arn
  function_name     = aws_lambda_function.lambda_dynamodb_stream_handler.arn
  starting_position = "LATEST"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "RuleForMyLambdaAccess"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "dynamodb_lambda_policy" {
  name   = "lambda-dynamodb-policy"
  role   = aws_iam_role.iam_for_lambda.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Sid": "AllowLambdaFunctionInvocation",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:AbortMultipartUpload",
                "lambda:InvokeFunction",
                "dynamodb:GetShardIterator",
                "s3:ListBucket",
                "dynamodb:DescribeStream",
                "s3:DeleteObject",
                "s3:GetObjectVersion",
                "s3:ListMultipartUploadParts",
                "dynamodb:GetRecords"
            ],
            "Resource": [
                "${aws_lambda_function.lambda_dynamodb_stream_handler.arn}",
                "${aws_dynamodb_table.dynamodb_table_users.arn}/stream/*",
                "arn:aws:s3:::newbucket-kkrackspace18",
                "arn:aws:s3:::newbucket-kkrackspace18/*"
            ]
        },
        {
            "Sid": "AllowLambdaFunctionToCreateLogs",
            "Effect": "Allow",
            "Action": "logs:*",
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Sid": "APIAccessForDynamoDBStreams",
            "Effect": "Allow",
            "Action": "dynamodb:ListStreams",
            "Resource": "${aws_dynamodb_table.dynamodb_table_users.arn}/stream/*"
        }
  ]
}
EOF
}

output "dynamodb_usersIds_arn" {
  value = aws_dynamodb_table.dynamodb_table_users.arn
    description = "The ARN of the DynamoDB Users Ids table"
}

output "lambda_processing_arn" {
  value = aws_lambda_function.lambda_dynamodb_stream_handler.arn
    description = "The ARN of the Lambda function processing the DynamoDB stream"
}