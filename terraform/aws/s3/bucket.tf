resource "aws_s3_bucket" "cloudfeeds_bucket" {
  bucket = var.bucket_name
  acl    = var.acl_value

  versioning {
    enabled = var.versioning
  }

  tags = {
    Name = var.bucket_name
  }
}
