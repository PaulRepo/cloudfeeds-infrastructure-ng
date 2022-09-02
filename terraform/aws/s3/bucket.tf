resource "aws_s3_bucket" "cloudfeeds_bucket" {
  bucket_prefix = var.bucket_name

  versioning {
    enabled = var.versioning
  }

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.cloudfeeds_bucket.id
  acl    = var.acl_value
}
