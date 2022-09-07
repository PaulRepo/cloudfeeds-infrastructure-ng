variable "bucket_name" {
  description = "S3 bucket name"
  type        = string 
  default     = "cloudfeeds-bucket"
}

variable "acl_value" {
  description = "S3 bucket acl value"
  type        = string 
  default     = "private"
}

variable "versioning" {
  description = "Versioning of the s3 bucket items"
  type        = string
  default     = "Disabled"
}
